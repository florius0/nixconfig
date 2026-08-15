{
  config,
  pkgs,
  ...
}:

let
  ompShell = pkgs.omp-shell;
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

      source "${pkgs.zsh-fzf-search}/share/zsh-fzf-search/search-widgets.zsh"
      source "${ompShell}/share/omp-shell/omp-shell.zsh"
      # Make Cmd+Backspace delete from cursor to line start.
      bindkey -M emacs '^U' backward-kill-line
    '';
  };
}
