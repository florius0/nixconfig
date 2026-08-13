{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      "~/.orbstack/ssh/config"
      "~/.ssh/config.local"
    ];

    settings."*" = { };

    extraConfig = ''
      SetEnv TERM=xterm-256color
    '';
  };
}
