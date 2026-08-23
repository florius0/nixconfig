{ config, pkgs, ... }:
{
  programs.aerospace = {
    enable = true;
    package = pkgs.aerospace;

    launchd.enable = true;

    settings = {
      config-version = 2;

      auto-reload-config = true;

      start-at-login = true;

      persistent-workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ];

      # Ghostty toggle_visibility hides on unfocus, so this needs to be false
      automatically-unhide-macos-hidden-apps = false;

      gaps = {
        inner = {
          horizontal = 8;
          vertical = 8;
        };
        outer = {
          left = 8;
          bottom = 8;
          top = 8;
          right = 8;
        };
      };

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        ctrl-space = ''
          exec-and-forget
                    app_id=com.mitchellh.ghostty
                    frontmost=$(osascript -e 'tell application "System Events" to get bundle identifier of first application process whose frontmost is true')
                    if [ "$frontmost" = "$app_id" ]; then
                      osascript -e 'tell application "System Events" to set visible of first application process whose bundle identifier is "com.mitchellh.ghostty" to false'
                      exit
                    fi

                    if [ "$(${pkgs.aerospace}/bin/aerospace list-windows --monitor all --app-bundle-id "$app_id" --count)" -gt 0 ]; then
                      osascript -e 'tell application "System Events" to set visible of first application process whose bundle identifier is "com.mitchellh.ghostty" to false'
                    fi

                    workspace=$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)
                    ${pkgs.aerospace}/bin/aerospace list-windows --monitor all --app-bundle-id "$app_id" --format "%{window-id}" |
                    while IFS= read -r window_id; do
                      ${pkgs.aerospace}/bin/aerospace layout --window-id "$window_id" floating
                      ${pkgs.aerospace}/bin/aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
                      ${pkgs.aerospace}/bin/aerospace layout --window-id "$window_id" floating
                    done
                    open -b "$app_id"
        '';

        alt-f = [
          "layout floating tiling"
          ''
            exec-and-forget sh -c '
                        osascript <<APPLESCRIPT
                        tell application "System Events"
                          set frontProcess to first application process whose frontmost is true
                          tell frontProcess
                            set windowPosition to position of front window
                            set windowSize to size of front window
                          end tell
                          tell application "Finder"
                            set screenBounds to bounds of window of desktop
                          end tell
                          set screenWidth to (item 3 of screenBounds) - (item 1 of screenBounds)
                          set screenHeight to (item 4 of screenBounds) - (item 2 of screenBounds)
                          set windowWidth to item 1 of windowSize
                          set windowHeight to item 2 of windowSize
                          set newX to (item 1 of screenBounds) + ((screenWidth - windowWidth) / 2)
                          set newY to (item 2 of screenBounds) + ((screenHeight - windowHeight) / 2)
                          tell frontProcess to set position of front window to {newX, newY}
                        end tell
                        APPLESCRIPT
                      '
          ''
        ];

        alt-backslash = ''
          exec-and-forget
                    current=$(${pkgs.aerospace}/bin/aerospace list-windows --focused --format "%{window-id}")
                    app=$(${pkgs.aerospace}/bin/aerospace list-windows --focused --format "%{app-bundle-id}")
                    ${pkgs.aerospace}/bin/aerospace list-windows --monitor all --app-bundle-id "$app" --format "%{window-id}" |
                    while IFS= read -r window_id; do
                      [ "$window_id" = "$current" ] || ${pkgs.aerospace}/bin/aerospace close --window-id "$window_id"
                    done
        '';
        alt-shift-backslash = "close-all-windows-but-current";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
      };

      on-window-detected = [
        {
          "if" = "test %{app-bundle-id} = com.apple.mail";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.iCal";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = com.vk.medesktop";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = ru.keepcoder.Telegram";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = com.hnc.Discord";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = com.tinyspeck.slackmacgap";
          run = "move-node-to-workspace 1";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Music";
          run = "move-node-to-workspace 2";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Safari";
          run = "move-node-to-workspace 3";
        }
        {
          "if" = "test %{app-bundle-id} = com.google.Chrome";
          run = "move-node-to-workspace 3";
        }
        {
          "if" = "test %{app-bundle-id} = com.openai.chat";
          run = "move-node-to-workspace 4";
        }
        {
          "if" = "test %{app-bundle-id} = com.openai.codex";
          run = "move-node-to-workspace 4";
        }
        {
          "if" = "test %{app-bundle-id} = com.anthropic.claudefordesktop";
          run = "move-node-to-workspace 4";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.dt.Xcode";
          run = "move-node-to-workspace 5";
        }
        {
          "if" = "test %{app-bundle-id} = com.microsoft.VSCode";
          run = "move-node-to-workspace 5";
        }
        {
          "if" = "test %{app-bundle-id} = com.arobas-music.guitarpro8";
          run = "move-node-to-workspace 6";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.logic10";
          run = "move-node-to-workspace 7";
        }
        {
          "if" = "test %{app-bundle-id} = com.obsproject.obs-studio";
          run = "move-node-to-workspace 7";
        }
        {
          "if" = "test %{app-bundle-id} = dev.kdrag0n.MacVirt";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.systempreferences";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.systemsettings";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Passwords";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.audio.AudioMIDISetup";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Notes";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.finder";
          run = "layout floating";
        }
        {
          "if" = "test %{window-title} ~= \"settings|preferences\"";
          run = "layout floating";
        }
        {
          "if" = "test %{app-bundle-id} = com.mitchellh.ghostty";
          run = [ "layout floating" ];
        }
      ];
    };
  };
}
