{
  writeShellScriptBin,
  writeTextFile,
  symlinkJoin,
  python3,
}:

let
  bin = writeShellScriptBin "omp-shell" ''
    exec ${python3}/bin/python3 ${./omp-shell.py} "$@"
  '';

  # Zsh integration: one private omp-shell RPC process per shell and
  # project, bound to `:`/`:<role>`/`:c` at the prompt. Depends on `omp`,
  # `omp-shell`, `fzf`, and `jq` being on PATH at runtime.
  zshIntegration = writeTextFile {
    name = "omp-shell-zsh-integration";
    destination = "/share/omp-shell/omp-shell.zsh";
    text = builtins.readFile ./omp-shell.zsh;
  };
in
symlinkJoin {
  name = "omp-shell";
  paths = [
    bin
    zshIntegration
  ];
}
