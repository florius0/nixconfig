{
  lib,
  flake,
  config,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;

    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;

    user = config.system.primaryUser;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };

    mutableTaps = false;
    autoMigrate = true;
  };

  # Package management via nix-darwin’s Homebrew module
  homebrew = {
    enable = true;

    # Keep taps in nix-darwin in sync with nix-homebrew (avoids drift):
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      # Entertainment Tools
      "webtorrent-cli"

      # Productivity Tools
      "monolith"
      "slackdump"
    ];

    casks = [
      # Communication tools
      "discord"
      "slack"

      # Development Tools
      "orbstack"
      "hammerspoon"

      # Encryption and security tools
      "openvpn-connect"

      # Utility Tools
      "anydesk"
      "macs-fan-control"

      # Entertainment Tools
      "transmission"

      # Productivity Tools
      "obs"

      # QuickLook Plugins
      "gltfquicklook"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "quicklookase"
    ];

    masApps = lib.mkIf (builtins.getEnv "ENABLE_MASAPPS" == "1") {
      "AdBlockPro" = 1018301773;
      "FoXray" = 6448898396;
      "Keynote" = 409183694;
      "No Shorts: Blocker for YouTube" = 6502996298;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Telegram" = 747648890;
      "VKMessenger" = 6449223858;
      "Xcode" = 497799835;
      "Windows App" = 1295203466;
    };
  };
}
