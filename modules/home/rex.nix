{ ... }:

{
  home.sessionPath = [
    "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS"
  ];

  programs.zsh.initContent = ''
    rex_session_pwd() {
      [[ -n "$REX_SESSION" ]] && (( $+commands[rex] )) || return 0
      local label="$PWD"
      case "$PWD" in
        "$HOME"|"$HOME"/*) label="~''${PWD#"$HOME"}" ;;
      esac
      rex session rename "$label"
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd rex_session_pwd
    rex_session_pwd
  '';

  xdg.configFile."rex/init.lua".text = ''
    rex.bind("shift+cmd+left", "pane.focus", { direction = "left" })
    rex.bind("shift+cmd+right", "pane.focus", { direction = "right" })
    rex.bind("cmd+r", "pane.send_key", { key = "ctrl+l" })
    rex.bind("ctrl+-", "pane.send_key", { key = "ctrl+shift+-" })
    rex.bind("ctrl+2", "pane.send_key", { key = "ctrl+space" })
    rex.bind("ctrl+3", "pane.send_key", { key = "esc" })
    rex.bind("ctrl+4", "pane.send_key", { key = "ctrl+\\" })
    rex.bind("ctrl+5", "pane.send_key", { key = "ctrl+]" })
    rex.bind("ctrl+6", "pane.send_key", { key = "ctrl+shift+6" })
    rex.bind("ctrl+7", "pane.send_key", { key = "ctrl+shift+-" })
    rex.bind("ctrl+8", "pane.send_key", { key = "backspace" })
    rex.bind("delete", "pane.send_key", { key = "ctrl+d" })
  '';
}
