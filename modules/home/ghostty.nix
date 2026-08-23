{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    themes = {
      "Xcode Dark" = {
        background = "#1f1e1e";
        foreground = "#ffffff";
        cursor-color = "#ffffff";
        cursor-text = "#1f1f24";
        selection-background = "#6e6e6e";
        selection-foreground = "#ffffff";
        palette = [
          "0=#000000"
          "1=#cd3131"
          "2=#0dbc79"
          "3=#e5e510"
          "4=#2472c8"
          "5=#bc3fbc"
          "6=#11a8cd"
          "7=#e5e5e5"
          "8=#666666"
          "9=#f14c4c"
          "10=#23d18b"
          "11=#f5f543"
          "12=#3b8eea"
          "13=#d670d6"
          "14=#29b8db"
          "15=#e5e5e5"
        ];
      };
    };

    settings = {
      auto-update = "off";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      font-feature = "calt, liga, dlig";
      theme = "Xcode Dark";
      palette-generate = true;
      background-opacity = 0.95;
      background-blur = "macos-glass-clear";
      bold-color = "bright";
      unfocused-split-opacity = 1.0;
      split-divider-color = "#e5e5e5";
      scrollback-limit = 10000000;
      mouse-scroll-multiplier = "precision:2.5,discrete:5";
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";
      cursor-style = "bar";
      cursor-style-blink = true;
      cursor-click-to-move = true;
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "notify";
      notify-on-command-finish-after = "1s";
      link-previews = true;
      macos-titlebar-style = "tabs";
      confirm-close-surface = true;
      working-directory = "home";
      copy-on-select = "clipboard";
      mouse-reporting = true;
      mouse-hide-while-typing = false;
      image-storage-limit = 320000000;
      keybind = [
        "super+r=text:\\x0c"
        "super+d=new_split:right"
        "super+shift+d=new_split:down"
        "super+w=close_surface"
        "super+shift+left=goto_split:left"
        "super+shift+right=goto_split:right"
        "super+left=text:\\x01"
        "super+right=text:\\x05"
        "alt+left=text:\\x1bb"
        "alt+right=text:\\x1bf"
        "alt+backspace=text:\\x1b\\x7f"
        "super+backspace=text:\\x15"
      ];
    };
  };
}
