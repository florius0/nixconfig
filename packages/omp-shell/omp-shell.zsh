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
    __omp_durations+=("${elapsed%.*}")
    while (( ${#__omp_commands} > 5 )); do
      __omp_commands=("${__omp_commands[@]:2}")
      __omp_cwds=("${__omp_cwds[@]:2}")
      __omp_codes=("${__omp_codes[@]:2}")
      __omp_durations=("${__omp_durations[@]:2}")
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
  breadcrumb="${PI_CODING_AGENT_DIR:-$HOME/.omp/agent}/terminal-sessions/${tty_name:t}"
  [[ -r "$breadcrumb" ]] || return
  [[ "$(sed -n '1p' "$breadcrumb")" == "$root" ]] || return
  sed -n '2p' "$breadcrumb"
}
__omp_socket() {
  local root="$1"
  print -r -- "${TMPDIR:-/tmp}/omp-shell-$UID-$$-$(print -rn -- "$root" | md5 -qs -)"
}

__omp_start() {
  local root="$1" socket="$2" session="$3" i
  [[ -S "$socket" ]] && return 0
  omp-shell server --socket "$socket" --root "$root" --session "$session" \
    </dev/null >"${socket}.log" 2>&1 &!
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
  for (( i = 1; i <= ${#__omp_commands}; i++ )); do
    command="${__omp_commands[i]//$'\n'/\\n}"
    print -r -- "- command: $command"
    print -r -- "  cwd: ${__omp_cwds[i]}"
    print -r -- "  exit_code: ${__omp_codes[i]}"
    print -r -- "  duration_ms: ${__omp_durations[i]}"
  done
  print -r -- "</shell-context>"
}

__omp_query() {
  local selector="$1" query="$2" root socket session context breadcrumb
  root=$(__omp_root)
  socket=$(__omp_socket "$root")
  session="${socket}.session"
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
        jq -r '.models[].selector' |
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
  session="${socket}.session"
  breadcrumb=$(__omp_breadcrumb "$root")
  [[ -s "$session" ]] || { print -u2 "No OMP shell session in this project"; return 1; }
  omp-shell stop --socket "$socket" >/dev/null 2>&1 || true
  rm -f "$socket"
  omp --cwd "$root" --resume "$(cat "$session")"
}
__omp_execute_line() {
  local line="$1" selector query
  case "$line" in
    ": "*) __omp_query "$OMP_SHELL_MODEL" "${line#: }" ;;
    :*)
      selector="${line%% *}"
      query="${line#"$selector"}"
      query="${query# }"
      selector="${selector#:}"
      [[ "$selector" == */* ]] || selector="@${selector}"
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
