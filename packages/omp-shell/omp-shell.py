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
