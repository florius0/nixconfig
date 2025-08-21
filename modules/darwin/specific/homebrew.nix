{ ... }:

{
  # Homebrew configuration
  homebrew = {
    enable = true;

    brews = [
      # Entertainment Tools
      "webtorrent-cli"
    ];

    casks = [
      # Development Tools
      "orbstack"
      "hammerspoon"

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

    masApps = {
      "Xcode" = 497799835;
      "FoXray" = 6448898396;
      "VKMessenger" = 6449223858;
      "AdBlockPro" = 1018301773;
      "Telegram" = 747648890;
      "Pages" = 409201541;
      "Numbers" = 409203825;
      "Keynote" = 409183694;
    };
  };
}
