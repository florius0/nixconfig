{ pkgs, config, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.file."${config.me.xdg.data}/jdk/21".source = pkgs.jdk21.home;
  home.file."${config.me.xdg.data}/jdk/25".source = pkgs.jdk25.home;
}
