{ lib, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];

    settings.ai.enabled = false;
  };
}
