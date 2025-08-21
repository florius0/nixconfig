{ config, pkgs, ... }:

{
  home.file."${config.me.xdg.config}/nano/.nanorc".text = ''
    include "${pkgs.nano}/share/nano/*.nanorc"
  '';
}
