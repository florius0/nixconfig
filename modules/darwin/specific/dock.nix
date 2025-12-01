{ config, pkgs, ... }:

{
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.0;
    largesize = 16;
    launchanim = true;
    magnification = false;
    mineffect = "genie";
    minimize-to-application = true;
    mru-spaces = false;
    show-recents = false;
    tilesize = 64;

    # Hot Corners – Top Right = Mission Control
    wvous-tr-corner = 2;

    # Expose
    expose-group-apps = true;

    persistent-apps = [
      # Activity Monitor
      { app = "/System/Applications/Utilities/Activity Monitor.app"; }

      # Spacer
      { spacer.small = true; }

      # Mail, Calendar, Notes
      { app = "/System/Applications/Mail.app"; }
      { app = "/System/Applications/Calendar.app"; }
      { app = "/System/Applications/Notes.app"; }

      # Spacer
      { spacer.small = true; }

      # Messengers
      { app = "/Applications/VK Мессенджер.app"; }
      { app = "/Applications/Telegram.app"; }
      { app = "/Applications/Discord.app"; }
      { app = "/Applications/Slack.app"; }

      # Spacer
      { spacer.small = true; }

      # Browsers
      { app = "/System/Cryptexes/App/System/Applications/Safari.app"; }
      { app = "${pkgs.google-chrome}/Applications/Google Chrome.app"; }

      # Music
      { app = "/System/Applications/Music.app"; }

      # Spacer
      { spacer.small = true; }

      # Dev tools
      { app = "/Applications/Xcode.app"; }
      { app = "${pkgs.vscode}/Applications/Visual Studio Code.app"; }
      { app = "${pkgs.iterm2}/Applications/iTerm2.app"; }
      { app = "/Applications/OrbStack.app"; }

      # Spacer
      { spacer.small = true; }

      # Creative tools
      { app = "/Applications/Guitar Pro 8.app"; }
      { app = "/Applications/Logic Pro.app"; }
      { app = "/Applications/OBS.app"; }

      # Spacer
      { spacer.small = true; }
    ];

    persistent-others = [
      {
        folder = {
          path = "/Users/${config.system.primaryUser}/Documents";
          arrangement = "name";
          displayas = "stack";
          showas = "grid";
        };
      }
      {
        folder = {
          path = "/Users/${config.system.primaryUser}/Downloads";
          arrangement = "date-added";
          displayas = "stack";
          showas = "grid";
        };
      }
    ];
  };
}
