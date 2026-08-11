{ config, pkgs, ... }:

let
  ompShellPython = pkgs.writeText "omp-shell.py" ''
    import argparse
    import json
    import signal
    import os
    import queue
    import selectors
    import socket
    import subprocess
    import sys
    import threading
    import time

    def send_json(stream, value):
        stream.write((json.dumps(value, ensure_ascii=False) + "\n").encode())
        stream.flush()

    class Rpc:
        def __init__(self, root, session, selector):
            args = ["omp", "--mode", "rpc", "--cwd", root]
            if selector:
                args += ["--model", selector]
            if session:
                args += ["--resume", session]
            self.proc = subprocess.Popen(
                args, cwd=root, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            self.frames = queue.Queue()
            self.reader = threading.Thread(target=self.read, daemon=True)
            self.reader.start()
            self.wait_type("ready", 30)
            self.call("get_state")

        def read(self):
            for line in self.proc.stdout:
                try:
                    self.frames.put(json.loads(line))
                except json.JSONDecodeError:
                    pass

        def wait_type(self, kind, timeout):
            end = time.monotonic() + timeout
            while time.monotonic() < end:
                if self.proc.poll() is not None:
                    error = self.proc.stderr.read().decode(errors="replace").strip()
                    raise RuntimeError(error or "OMP RPC exited during startup")
                try:
                    frame = self.frames.get(timeout=max(0.05, end - time.monotonic()))
                except queue.Empty:
                    continue
                if frame.get("type") == kind:
                    return frame
            raise RuntimeError("OMP RPC startup timed out")

        def call(self, kind, **kwargs):
            ident = f"omp-shell-{time.monotonic_ns()}"
            send_json(self.proc.stdin, {"id": ident, "type": kind, **kwargs})
            while True:
                frame = self.frames.get(timeout=120)
                if frame.get("id") == ident:
                    if not frame.get("success", False):
                        raise RuntimeError(frame.get("error", f"OMP {kind} failed"))
                    return frame.get("data", {})

        def ui(self, frame):
            try:
                with open("/dev/tty", "r+", encoding="utf-8") as tty:
                    method = frame.get("method")
                    if method == "confirm":
                        tty.write(f"\n{frame.get('message', frame.get('title', 'Confirm'))} [y/N] ")
                        tty.flush()
                        answer = tty.readline().strip().lower()
                        payload = {"confirmed": answer in ("y", "yes")}
                    elif method == "input":
                        tty.write(f"\n{frame.get('title', 'Input')}: ")
                        tty.flush()
                        payload = {"value": tty.readline().rstrip("\n")}
                    elif method == "select":
                        options = frame.get("options", [])
                        for index, option in enumerate(options, 1):
                            label = option.get("label", option.get("value", option)) if isinstance(option, dict) else option
                            tty.write(f"{index}) {label}\n")
                        tty.write("Select: ")
                        tty.flush()
                        index = int(tty.readline().strip()) - 1
                        option = options[index]
                        payload = {"value": option.get("value", option) if isinstance(option, dict) else option}
                    else:
                        return False
            except (EOFError, ValueError, KeyboardInterrupt, OSError, IndexError):
                payload = {"cancelled": True}
            send_json(self.proc.stdin, {"type": "extension_ui_response", "id": frame["id"], **payload})
            return True


        def prompt(self, message, emit):
            ident = f"omp-shell-{time.monotonic_ns()}"
            send_json(self.proc.stdin, {"id": ident, "type": "prompt", "message": message})
            while True:
                frame = self.frames.get()
                typ = frame.get("type")
                if typ == "message_update":
                    event = frame.get("assistantMessageEvent", frame.get("data", {}))
                    delta = event.get("delta", "") if isinstance(event, dict) else ""
                    if delta:
                        emit(delta)
                elif typ == "extension_ui_request":
                    if frame.get("method") == "setWidget":
                        continue
                    if self.ui(frame):
                        continue
                    emit("\nOMP requested unsupported UI; use :c to continue in full OMP.\n")
                    self.call("abort")
                    return
                elif typ == "response" and frame.get("id") == ident:
                    if not frame.get("success", False):
                        raise RuntimeError(frame.get("error", "OMP prompt failed"))
                    if frame.get("data", {}).get("agentInvoked") is False:
                        break
                elif typ == "prompt_result" and frame.get("id") == ident:
                    if frame.get("agentInvoked") is False:
                        break
                elif typ == "agent_end" and frame.get("isTerminal") is not False:
                    break
                elif typ == "response" and frame.get("success") is False:
                    raise RuntimeError(frame.get("error", "OMP request failed"))

        def close(self):
            try:
                self.proc.stdin.close()
            except Exception:
                pass
            try:
                self.proc.terminate()
                self.proc.wait(timeout=2)
            except Exception:
                self.proc.kill()

    ACTIVE_RPC = None

    def abort_active_rpc(signum, frame):
        if ACTIVE_RPC is not None:
            try:
                send_json(ACTIVE_RPC.proc.stdin, {"type": "abort"})
            except OSError:
                pass
    def project_root(cwd):
        try:
            return subprocess.check_output(
                ["git", "-C", cwd, "rev-parse", "--show-toplevel"],
                text=True, stderr=subprocess.DEVNULL,
            ).strip()
        except subprocess.CalledProcessError:
            return cwd

    def state_path(root, token):
        base = os.environ.get("TMPDIR", "/tmp")
        os.makedirs(base, exist_ok=True)
        safe = str(abs(hash(root)))
        return os.path.join(base, f"omp-shell-{token}-{safe}.session")
    def run_server(path, root, session_path):
        global ACTIVE_RPC
        try:
            os.unlink(path)
        except FileNotFoundError:
            pass
        server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        server.bind(path)
        os.chmod(path, 0o600)
        server.listen(1)
        with open(path + ".pid", "w") as pid_file:
            pid_file.write(str(os.getpid()))
        signal.signal(signal.SIGUSR1, abort_active_rpc)
        rpc = None
        try:
            while True:
                conn, _ = server.accept()
                with conn, conn.makefile("rwb") as stream:
                    try:
                        request = json.loads(stream.readline())
                        command = request["command"]
                        if rpc is None or rpc.proc.poll() is not None:
                            rpc = Rpc(root, session_path if os.path.exists(session_path) else None,
                                      request.get("selector", "@default"))
                            ACTIVE_RPC = rpc
                        if command == "prompt":
                            selector = request.get("selector", "@default")
                            if selector:
                                chosen = rpc.call("get_state").get("model", {})
                                if request.get("resolved") != f"{chosen.get('provider')}/{chosen.get('id')}":
                                    probe = Rpc(root, None, selector)
                                    model = probe.call("get_state").get("model", {})
                                    probe.close()
                                    rpc.call("set_model", provider=model["provider"], modelId=model["id"])
                            message = request["context"] + "\n" + request["message"]
                            rpc.prompt(message, lambda text: send_json(stream, {"stream": text}))
                            state = rpc.call("get_state")
                            with open(session_path, "w") as state_file:
                                state_file.write(state.get("sessionFile", ""))
                            send_json(stream, {"ok": True, "model": state.get("model", {})})
                        elif command == "models":
                            data = rpc.call("get_available_models")
                            send_json(stream, {"ok": True, "data": data})
                        elif command == "resolve":
                            probe = Rpc(root, None, request["selector"])
                            state = probe.call("get_state")
                            probe.close()
                            send_json(stream, {"ok": True, "model": state.get("model", {})})
                        elif command == "stop":
                            send_json(stream, {"ok": True})
                            break
                    except Exception as error:
                        if request.get("command") in ("prompt", "resolve") and request.get("selector"):
                            error = f"Unknown OMP role/model: {request['selector'].lstrip('@')}"
                        send_json(stream, {"ok": False, "error": str(error)})
        finally:
            ACTIVE_RPC = None
            if rpc:
                rpc.close()
            server.close()
            for suffix in ("", ".pid"):
                try:
                    os.unlink(path + suffix)
                except FileNotFoundError:
                    pass
    def client(path, request):
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
            sock.connect(path)
            stream = sock.makefile("rwb")
            send_json(stream, request)
            while True:
                reply = json.loads(stream.readline())
                if "stream" in reply:
                    print(reply["stream"], end="", flush=True)
                    continue
                break
        if not reply.get("ok"):
            print(reply.get("error", "OMP shell bridge failed"), file=sys.stderr)
            return 1
        if request["command"] == "prompt":
            print()
        elif request["command"] == "resolve":
            print(json.dumps(reply["model"], ensure_ascii=False))
        elif request["command"] == "models":
            for model in reply.get("data", {}).get("models", []):
                print(f'{model.get("provider", "")}/{model.get("id", "")}')
        return 0

    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["server", "prompt", "models", "resolve", "stop"])
    parser.add_argument("--socket", required=True)
    parser.add_argument("--root")
    parser.add_argument("--session")
    parser.add_argument("--selector")
    parser.add_argument("--resolved")
    parser.add_argument("--context", default="")
    parser.add_argument("message", nargs="*")
    args = parser.parse_args()
    if args.command == "server":
        run_server(args.socket, args.root, args.session)
    else:
        request = {
            "command": args.command, "selector": args.selector,
            "resolved": args.resolved, "context": args.context,
            "message": " ".join(args.message),
        }
        raise SystemExit(client(args.socket, request))
  '';
  ompShell = pkgs.writeShellScriptBin "omp-shell" ''
    exec ${pkgs.python3}/bin/python ${ompShellPython} "$@"
  '';
in
{
  home.packages = [ ompShell ];

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      append = true;
      findNoDups = true;
      share = true;
    };

    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-syntax-highlighting"
      ];
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -alh";
      tree = "eza --tree";
      nano = "nano --rcfile ${config.xdg.configHome}/nano/.nanorc";
    };

    initContent = ''
      # Let Nix authenticate GitHub fetches with the token managed by `gh`.
      # Keep it in the shell environment rather than writing it to nix.conf.
      if (( $+commands[gh] )); then
        __github_token=$(gh auth token --hostname github.com 2>/dev/null)
        if [[ -n "$__github_token" ]]; then
          if [[ -n "$NIX_CONFIG" ]]; then
            export NIX_CONFIG="$NIX_CONFIG"$'\n'"access-tokens = github.com=$__github_token"
          else
            export NIX_CONFIG="access-tokens = github.com=$__github_token"
          fi
        fi
        unset __github_token
      fi

      __fzf() {
        fzf --reverse --multi "$@"
      }

      __fd() {
        fd -H --full-path "$1"
      }

      __preview () {
        echo '
          [ -d {1} ] && exa -lah --color always {1} || \
          ( [ -f {1} ] && [[ "{2}" =~ ^[0-9]+$ ]] && bat --style=numbers --color=always --highlight-line {2} {1} || \
            bat --style=numbers --color=always {1} )
        '
      }

      fs() {
        local search_dir="''${1:-}"
        [ -n "$1" ] && shift

        __fd "$search_dir" | __fzf --ansi \
          --preview "$(__preview {})" \
          --bind 'enter:accept' \
          --print0 $@ | tr -d '\0'
      }

      fsc() {
        local search_dir="''${1:-}"
        [ -n "$1" ] && shift

        __fd "$search_dir" | __fzf --ansi --disabled \
          --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
          --delimiter : \
          --preview "$(__preview {2} {1})" \
          --preview-window '+{2}' \
          --bind 'enter:accept' \
          --print0 $@ | tr -d '\0'
      }

      fse() {
        local search_dir="''${1:-}"
        [ -n "$1" ] && shift

        __fd "$search_dir" | __fzf --ansi \
          --preview "$(__preview {})" \
          --bind 'enter:become($EDITOR {1})' \
          $@
      }

      fsce() {
        local search_dir="''${1:-}"
        [ -n "$1" ] && shift

        __fd "$search_dir" | __fzf --ansi --disabled \
          --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
          --delimiter : \
          --preview "$(__preview {2} {1})" \
          --preview-window '+{2}' \
          --bind 'enter:become($EDITOR +{2}:{3} {1})' $@
      }

      __fs() {
        local file
        file=$(__fd | __fzf --height 40% --ansi \
          --preview "$(__preview {})" \
          --bind 'enter:accept' \
          --print0 | tr -d '\0')

        [[ -n "$file" ]] && LBUFFER+="$file"
        zle reset-prompt
      }

      __fsc() {
        local result
        result=$(__fd | __fzf --height 40% --ansi --disabled \
          --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
          --delimiter : \
          --preview "$(__preview {2} {1})" \
          --preview-window '+{2}' \
          --bind 'enter:accept' --print0 | tr -d '\0')

        [[ -n "$result" ]] && LBUFFER+="$result"
        zle reset-prompt
      }

      # Register functions as ZLE widgets
      zle -N __fs
      zle -N __fsc

      # Bind to keys
      bindkey '^F' __fs
      bindkey '^T' __fsc
      # Thin OMP bridge: one private RPC process per shell and project.
      typeset -g OMP_SHELL_MODEL="@default"
      typeset -ga __omp_commands __omp_cwds __omp_codes __omp_durations
      typeset -g __omp_command __omp_command_cwd __omp_command_started

      __omp_preexec() {
        __omp_command="$1"
        __omp_command_cwd="$PWD"
        __omp_command_started=$EPOCHREALTIME
      }

      __omp_precmd() {
        local __omp_status=$?
        if [[ -n "$__omp_command" && -n "$__omp_command_started" ]]; then
          local elapsed=$(( (EPOCHREALTIME - __omp_command_started) * 1000 ))
          __omp_commands+=("$__omp_command")
          __omp_cwds+=("$__omp_command_cwd")
          __omp_codes+=("$__omp_status")
          __omp_durations+=("''${elapsed%.*}")
          while (( ''${#__omp_commands} > 5 )); do
            __omp_commands=("''${__omp_commands[@]:2}")
            __omp_cwds=("''${__omp_cwds[@]:2}")
            __omp_codes=("''${__omp_codes[@]:2}")
            __omp_durations=("''${__omp_durations[@]:2}")
          done
        fi
        __omp_command=
        __omp_command_started=
      }

      autoload -Uz add-zsh-hook
      add-zsh-hook preexec __omp_preexec
      add-zsh-hook precmd __omp_precmd

      __omp_root() {
        git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || print -r -- "$PWD"
      }
      __omp_breadcrumb() {
        local root="$1" tty_name breadcrumb
        tty_name=$(tty 2>/dev/null) || return
        breadcrumb="''${PI_CODING_AGENT_DIR:-$HOME/.omp/agent}/terminal-sessions/''${tty_name:t}"
        [[ -r "$breadcrumb" ]] || return
        [[ "$(sed -n '1p' "$breadcrumb")" == "$root" ]] || return
        sed -n '2p' "$breadcrumb"
      }
      __omp_socket() {
        local root="$1"
        print -r -- "''${TMPDIR:-/tmp}/omp-shell-$UID-$$-$(print -rn -- "$root" | md5 -qs -)"
      }

      __omp_start() {
        local root="$1" socket="$2" session="$3" i
        [[ -S "$socket" ]] && return 0
        omp-shell server --socket "$socket" --root "$root" --session "$session" \
          </dev/null >"''${socket}.log" 2>&1 &!
        for (( i = 0; i < 100; i++ )); do
          [[ -S "$socket" ]] && return 0
          sleep 0.01
        done
        print -u2 "OMP shell RPC did not start"
        return 1
      }

      __omp_context() {
        local i command
        print -r -- "<shell-context>"
        print -r -- "cwd: $PWD"
        print -r -- "recent_commands:"
        for (( i = 1; i <= ''${#__omp_commands}; i++ )); do
          command="''${__omp_commands[i]//$'\n'/\\n}"
          print -r -- "- command: $command"
          print -r -- "  cwd: ''${__omp_cwds[i]}"
          print -r -- "  exit_code: ''${__omp_codes[i]}"
          print -r -- "  duration_ms: ''${__omp_durations[i]}"
        done
        print -r -- "</shell-context>"
      }

      __omp_query() {
        local selector="$1" query="$2" root socket session context breadcrumb
        root=$(__omp_root)
        socket=$(__omp_socket "$root")
        session="''${socket}.session"
        breadcrumb=$(__omp_breadcrumb "$root")
        [[ -n "$breadcrumb" ]] && print -r -- "$breadcrumb" >| "$session"
        __omp_start "$root" "$socket" "$session" || return
        context=$(__omp_context)
        trap '[[ -r "$socket.pid" ]] && kill -USR1 "$(cat "$socket.pid")" 2>/dev/null' INT
        if ! omp-shell prompt --socket "$socket" --selector "$selector" \
          --resolved "$selector" --context "$context" -- "$query"; then
          rm -f "$socket" "$session"
        fi
        trap - INT
      }

      __omp_select() {
        local choice
        choice=$(
          {
            print -r -- 'default'
            print -r -- 'smol'
            print -r -- 'slow'
            print -r -- 'plan'
            print -r -- 'task'
            print -r -- 'commit'
            print -r -- 'designer'
            print -r -- 'vision'
            print -r -- 'advisor'
            print -r -- 'tiny'
            omp models --json 2>/dev/null |
              ${pkgs.jq}/bin/jq -r '.models[].selector' |
              sort -u
          } | fzf --reverse --height 40% --prompt='OMP role/model> '
        )
        if [[ -n "$choice" ]]; then
          OMP_SHELL_MODEL="@$choice"
          [[ "$choice" == */* ]] && OMP_SHELL_MODEL="$choice"
          LBUFFER=":$choice "
          RBUFFER=
        fi
        zle redisplay
      }

      __omp_continue() {
        local root socket session breadcrumb
        root=$(__omp_root)
        socket=$(__omp_socket "$root")
        session="''${socket}.session"
        breadcrumb=$(__omp_breadcrumb "$root")
        [[ -s "$session" ]] || { print -u2 "No OMP shell session in this project"; return 1; }
        omp-shell stop --socket "$socket" >/dev/null 2>&1 || true
        rm -f "$socket"
        omp --cwd "$root" --resume "$(cat "$session")"
      }
      __omp_execute_line() {
        local line="$1" selector query
        case "$line" in
          ": "*) __omp_query "$OMP_SHELL_MODEL" "''${line#: }" ;;
          :*)
            selector="''${line%% *}"
            query="''${line#"$selector"}"
            query="''${query# }"
            selector="''${selector#:}"
            [[ "$selector" == */* ]] || selector="@''${selector}"
            [[ -n "$query" ]] || { print -u2 "Usage: :<role/model> <query>"; return 1; }
            __omp_query "$selector" "$query" ;;
        esac
      }

      alias ':c'='__omp_continue'
      alias ':continue'='__omp_continue'

      __omp_accept_line() {
        local line="$BUFFER"
        case "$line" in
          :) __omp_select; return ;;
          :c|:continue) zle .accept-line; return ;;
          ": "*|:*)
            print -s -- "$line"
            zle -I
            print
            __omp_execute_line "$line"
            BUFFER=
            zle -R
            return ;;
        esac
        zle .accept-line
      }
      zle -N __omp_accept_line
      for __omp_keymap in emacs viins vicmd; do
        bindkey -M "$__omp_keymap" '^M' __omp_accept_line
        bindkey -M "$__omp_keymap" '^J' __omp_accept_line
      done
      bindkey '^M' __omp_accept_line
      bindkey '^J' __omp_accept_line
    '';
  };
}
