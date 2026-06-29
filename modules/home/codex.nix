{
  config,
  lib,
  pkgs,
  ...
}:

let
  codexHome = "${config.home.homeDirectory}/.codex";
  codexLogDir = "/tmp/codex-${config.home.username}-logs";
in
{
  home.sessionVariables = {
    # Keep the opt-in TUI session recorder disabled. If it is enabled manually,
    # force its output into /tmp as well.
    CODEX_TUI_RECORD_SESSION = "0";
    CODEX_TUI_SESSION_LOG_PATH = "${codexLogDir}/tui-session.jsonl";
  };

  home.activation.codexLogDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    codex_home="${codexHome}"
    log_link="$codex_home/log"
    target="${codexLogDir}"

    mkdir -p "$target"
    chmod 700 "$target"
    mkdir -p "$codex_home"

    if [ -L "$log_link" ]; then
      current="$(${pkgs.coreutils}/bin/readlink "$log_link" || true)"
      if [ "$current" != "$target" ]; then
        rm "$log_link"
        ln -s "$target" "$log_link"
      fi
    elif [ -e "$log_link" ]; then
      backup="$codex_home/log.home-manager-backup-$(date +%Y%m%d%H%M%S)"
      mv "$log_link" "$backup"
      ln -s "$target" "$log_link"
      echo "Moved existing Codex log directory to $backup"
    else
      ln -s "$target" "$log_link"
    fi
  '';
}
