# modules/darwin/specific/mac-app-util.nix
{
  config,
  flake,
  lib,
  ...
}:

let
  inherit (flake) inputs;
  inherit
    (config.home-manager.users.${config.system.primaryUser}.targets.darwin.launchServices.scripts)
    launchServiceApps
    unregisterApp
    ;
in
{
  imports = [ inputs.mac-app-util.darwinModules.default ];

  home-manager.sharedModules = [
    flake.inputs.mac-app-util.homeManagerModules.default
  ];

  # nix-darwin creates its trampolines after Home Manager activation.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [[ ! -v DRY_RUN && "$(ps -p "$PPID" -ww -o args= || true)" != *" --dry-run"* ]]; then
      for app in /Applications/Nix\ Trampolines/*.app; do
        [ -e "$app" ] || continue
        launchctl asuser "$(id -u ${lib.escapeShellArg config.system.primaryUser})" \
          sudo -u ${lib.escapeShellArg config.system.primaryUser} --set-home \
          ${unregisterApp} ${launchServiceApps} "$app"
      done
    fi
  '';
}
