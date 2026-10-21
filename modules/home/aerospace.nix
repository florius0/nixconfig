{ pkgs, ... }:
let
  aerospace = "${pkgs.aerospace}/bin/aerospace";

  switchWorkspace = pkgs.writeShellScript "aerospace-workspace" ''
    set -eu
    workspace=$1
    app=$2
    bundle=$3
    layout=$4

    if [ "$(${aerospace} list-workspaces --focused)" = "$workspace" ]; then
      ${aerospace} workspace-back-and-forth
      exit
    fi

    ${aerospace} workspace "$workspace"
    [ "$(${aerospace} list-windows --workspace "$workspace" --count)" -eq 0 ] || exit 0

    # Reuse a default-app window that was manually moved elsewhere.
    windows=$(${aerospace} list-windows --monitor all --app-bundle-id "$bundle" --format '%{window-id}')
    if [ -n "$windows" ]; then
      window_id=''${windows%%$'\n'*}
      ${aerospace} move-node-to-workspace --window-id "$window_id" "$workspace"
      ${aerospace} layout --window-id "$window_id" "$layout"
      if [ "$workspace" = T ]; then
        ${aerospace} fullscreen --window-id "$window_id" on
      fi
      /usr/bin/open -a "$app"
      ${aerospace} focus --window-id "$window_id"
    elif [ "$bundle" = com.apple.finder ]; then
      /usr/bin/open -a Finder "$HOME"
    else
      /usr/bin/open -a "$app"
    fi
  '';

in
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
        "G"
        "A"
        "S"
        "D"
        "F"
        "E"
        "R"
        "C"
        "V"
        "X"
        "Z"
        "T"
      ];

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
        ctrl-alt-shift-1 = "workspace --auto-back-and-forth 1";
        ctrl-alt-shift-2 = "workspace --auto-back-and-forth 2";
        ctrl-alt-shift-3 = "workspace --auto-back-and-forth 3";
        ctrl-alt-shift-4 = "workspace --auto-back-and-forth 4";
        ctrl-alt-shift-5 = "workspace --auto-back-and-forth 5";
        ctrl-alt-shift-6 = "workspace --auto-back-and-forth 6";
        ctrl-alt-shift-7 = "workspace --auto-back-and-forth 7";
        ctrl-alt-shift-8 = "workspace --auto-back-and-forth 8";
        ctrl-alt-shift-9 = "workspace --auto-back-and-forth 9";

        ctrl-alt-shift-cmd-1 = "move-node-to-workspace 1";
        ctrl-alt-shift-cmd-2 = "move-node-to-workspace 2";
        ctrl-alt-shift-cmd-3 = "move-node-to-workspace 3";
        ctrl-alt-shift-cmd-4 = "move-node-to-workspace 4";
        ctrl-alt-shift-cmd-5 = "move-node-to-workspace 5";
        ctrl-alt-shift-cmd-6 = "move-node-to-workspace 6";
        ctrl-alt-shift-cmd-7 = "move-node-to-workspace 7";
        ctrl-alt-shift-cmd-8 = "move-node-to-workspace 8";
        ctrl-alt-shift-cmd-9 = "move-node-to-workspace 9";

        ctrl-alt-shift-g = "exec-and-forget ${switchWorkspace} G Steam com.valvesoftware.steam.helper tiling";
        ctrl-alt-shift-a = "exec-and-forget ${switchWorkspace} A ChatGPT com.openai.codex tiling";
        ctrl-alt-shift-s = "exec-and-forget ${switchWorkspace} S Safari com.apple.Safari tiling";
        ctrl-alt-shift-d = "exec-and-forget ${switchWorkspace} D 'Visual Studio Code' com.microsoft.VSCode tiling";
        ctrl-alt-shift-f = "exec-and-forget ${switchWorkspace} F Finder com.apple.finder tiling";
        ctrl-alt-shift-e = "exec-and-forget ${switchWorkspace} E Music com.apple.Music tiling";
        ctrl-alt-shift-r = "exec-and-forget ${switchWorkspace} R Notes com.apple.Notes tiling";
        ctrl-alt-shift-c = "exec-and-forget ${switchWorkspace} C Telegram ru.keepcoder.Telegram tiling";
        ctrl-alt-shift-v = "exec-and-forget ${switchWorkspace} V 'Guitar Pro 8' com.arobas-music.guitarpro8 tiling";
        ctrl-alt-shift-x = "exec-and-forget ${switchWorkspace} X Mail com.apple.mail tiling";
        ctrl-alt-shift-z = "exec-and-forget ${switchWorkspace} Z 'Activity Monitor' com.apple.ActivityMonitor tiling";
        ctrl-alt-shift-w = "exec-and-forget ${switchWorkspace} T Ghostty com.mitchellh.ghostty floating";
        ctrl-alt-shift-t = "exec-and-forget ${switchWorkspace} T Ghostty com.mitchellh.ghostty floating";

        ctrl-alt-shift-cmd-g = "move-node-to-workspace G";
        ctrl-alt-shift-cmd-a = "move-node-to-workspace A";
        ctrl-alt-shift-cmd-s = "move-node-to-workspace S";
        ctrl-alt-shift-cmd-d = "move-node-to-workspace D";
        ctrl-alt-shift-cmd-f = "move-node-to-workspace F";
        ctrl-alt-shift-cmd-e = "move-node-to-workspace E";
        ctrl-alt-shift-cmd-r = "move-node-to-workspace R";
        ctrl-alt-shift-cmd-c = "move-node-to-workspace C";
        ctrl-alt-shift-cmd-v = "move-node-to-workspace V";
        ctrl-alt-shift-cmd-x = "move-node-to-workspace X";
        ctrl-alt-shift-cmd-z = "move-node-to-workspace Z";
        ctrl-alt-shift-cmd-w = "move-node-to-workspace T";
        ctrl-alt-shift-cmd-t = "move-node-to-workspace T";

        ctrl-alt-shift-slash = "layout tiles horizontal vertical";
        ctrl-alt-shift-comma = "layout accordion horizontal vertical";

        ctrl-alt-shift-h = "focus left";
        ctrl-alt-shift-j = "focus down";
        ctrl-alt-shift-k = "focus up";
        ctrl-alt-shift-l = "focus right";

        ctrl-alt-shift-cmd-h = "move left";
        ctrl-alt-shift-cmd-j = "move down";
        ctrl-alt-shift-cmd-k = "move up";
        ctrl-alt-shift-cmd-l = "move right";

        ctrl-alt-shift-esc = [
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

        ctrl-alt-shift-backslash = ''
          exec-and-forget
                    current=$(${pkgs.aerospace}/bin/aerospace list-windows --focused --format "%{window-id}")
                    app=$(${pkgs.aerospace}/bin/aerospace list-windows --focused --format "%{app-bundle-id}")
                    ${pkgs.aerospace}/bin/aerospace list-windows --monitor all --app-bundle-id "$app" --format "%{window-id}" |
                    while IFS= read -r window_id; do
                      [ "$window_id" = "$current" ] || ${pkgs.aerospace}/bin/aerospace close --window-id "$window_id"
                    done
        '';
        ctrl-alt-shift-cmd-backslash = "close-all-windows-but-current";

        ctrl-alt-shift-enter = "fullscreen";
        ctrl-alt-shift-cmd-enter = "fullscreen off";

        ctrl-alt-shift-cmd-minus = "resize smart -50";
        ctrl-alt-shift-cmd-equal = "resize smart +50";
        ctrl-alt-shift-cmd-0 = "balance-sizes";

        ctrl-alt-shift-tab = "workspace-back-and-forth";
        ctrl-alt-shift-cmd-tab = "move-workspace-to-monitor --wrap-around next";
      };

      on-window-detected = [
        {
          "if" =
            ''test %{app-bundle-id} = "com.valvesoftware.steam" || test %{app-bundle-id} = "com.valvesoftware.steam.helper" || test %{app-bundle-id} = "net.battle.app" || test %{app-bundle-id} = "unity.Blizzard Entertainment.Hearthstone" || test %{app-bundle-id} = "com.gaijinent.WarThunderDL" || test %{app-bundle-id} = "com.gaijinent.WarThunder" || test %{app-bundle-id} = "org.polymc.PolyMC" || test %{app-bundle-path} ~= "/steamapps/common/" || test %{app-exec-path} ~= "/steamapps/common/" || test %{app-name} ~= "^PolyMC: "'';
          run = [
            "move-node-to-workspace G"
            "layout tiling"
          ];
        }
        # Utility apps, settings dialogs and authentication prompts stay on the current workspace.
        {
          "if" =
            "test %{app-bundle-id} = com.apple.systempreferences || test %{app-bundle-id} = com.apple.systemsettings || test %{app-bundle-id} = com.apple.Passwords || test %{app-bundle-id} = com.apple.audio.AudioMIDISetup";
          run = "layout floating";
        }
        {
          "if" = ''test %{window-title} ~= "settings|preferences"'';
          run = "layout floating";
        }
        {
          "if" =
            "test %{app-bundle-id} = com.apple.LocalAuthentication.UIAgent || test %{app-bundle-id} = com.apple.SecurityAgent";
          run = "layout floating";
        }
        {
          "if" =
            "test %{app-bundle-id} = com.openai.chat || test %{app-bundle-id} = com.openai.codex || test %{app-bundle-id} = com.anthropic.claudefordesktop";
          run = [
            "move-node-to-workspace A"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Safari || test %{app-bundle-id} = com.google.Chrome";
          run = [
            "move-node-to-workspace S"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.microsoft.VSCode || test %{app-bundle-id} = com.apple.dt.Xcode";
          run = [
            "move-node-to-workspace D"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.finder";
          run = [
            "move-node-to-workspace F"
            "layout floating"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Music";
          run = [
            "move-node-to-workspace E"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.Notes";
          run = [
            "move-node-to-workspace R"
            "layout floating"
          ];
        }
        {
          "if" =
            "test %{app-bundle-id} = ru.keepcoder.Telegram || test %{app-bundle-id} = com.vk.medesktop || test %{app-bundle-id} = com.hnc.Discord || test %{app-bundle-id} = com.tinyspeck.slackmacgap || test %{app-bundle-id} = com.apple.MobileSMS";
          run = [
            "move-node-to-workspace C"
            "layout tiling"
          ];
        }
        {
          "if" =
            "test %{app-bundle-id} = com.arobas-music.guitarpro8 || test %{app-bundle-id} = com.apple.logic10 || test %{app-bundle-id} = com.obsproject.obs-studio";
          run = [
            "move-node-to-workspace V"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.apple.mail || test %{app-bundle-id} = com.apple.iCal";
          run = [
            "move-node-to-workspace X"
            "layout tiling"
          ];
        }
        {
          "if" =
            "test %{app-bundle-id} = com.apple.ActivityMonitor || test %{app-bundle-id} = dev.kdrag0n.MacVirt || test %{app-bundle-id} = org.openvpn.client.app || test %{app-bundle-id} = org.redshieldvpn.redshieldvpn || test %{app-bundle-id} = com.crystalidea.macsfancontrol";
          run = [
            "move-node-to-workspace Z"
            "layout tiling"
          ];
        }
        {
          "if" = "test %{app-bundle-id} = com.mitchellh.ghostty";
          # Native macOS tabs appear as separate windows to AeroSpace.
          run = [
            "move-node-to-workspace T"
            "layout floating"
            "fullscreen on"
          ];
        }
        {
          "if" = "true";
          run = "move-node-to-workspace 1";
        }
      ];
    };
  };
}
