{
  lib,
  writeTextFile,
  role ? [ ],
  model ? [ ],
}:

let
  prefix = "?";
  alias = name: command: "alias ${lib.escapeShellArg name}=${lib.escapeShellArg command}";
  modelAliases = map (name: alias "${prefix}${name}" "omp --model ${name}") model;
  roleAliases = map (name: alias "${prefix}${name}" "omp --model @${name}") role;
in
writeTextFile {
  name = "omp-shell-zsh-integration";
  destination = "/share/omp-shell/omp-shell.zsh";
  text =
    lib.concatStringsSep "\n" (
      [
        (alias prefix "omp -p")
        (alias "${prefix}c" "omp --continue")
        (alias "${prefix}continue" "omp --continue")
      ]
      ++ modelAliases
      ++ roleAliases
    )
    + "\n";
}
