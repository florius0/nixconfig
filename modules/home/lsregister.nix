{
  config,
  lib,
  pkgs,
  ...
}:

let
  lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
  launchServiceApps = pkgs.writeText "launch-service-apps.js" ''
    ObjC.import("AppKit");

    function run(argv) {
      const mode = argv[0];
      const current = $(argv[1]).stringByResolvingSymlinksInPath.js;
      const bundle = $.NSBundle.bundleWithPath(current);
      const identifier = bundle.bundleIdentifier;
      if (!identifier.js) throw new Error("Missing bundle identifier: " + current);

      const candidates = $.NSWorkspace.sharedWorkspace
        .URLsForApplicationsWithBundleIdentifier(identifier);
      const paths = [];
      for (let i = 0; i < candidates.count; i++) {
        const path = candidates.objectAtIndex(i).path.js;
        if (mode === "registered" && path === current) paths.push(path);
        if (mode === "stale" && path !== current && path.startsWith("/nix/store/")) {
          paths.push(path);
        }
      }
      return paths.join("\n");
    }
  '';
  unregisterApp = pkgs.writeShellScript "unregister-launch-service-app" ''
    set -e

    lookup_script=$1
    app=$2
    lsregister=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

    registered_app=$(/usr/bin/osascript -l JavaScript "$lookup_script" registered "$app")
    [ -n "$registered_app" ] || exit 0

    if output=$("$lsregister" -u "$registered_app" 2>&1); then
      [ -z "$output" ] || printf '%s\n' "$output"
      exit 0
    else
      status=$?
    fi

    # Spotlight can report failure after Launch Services has removed the entry.
    remaining=$(/usr/bin/osascript -l JavaScript "$lookup_script" registered "$app")
    if [[ -z "$remaining" && "$output" == "failed to scan $registered_app: -10814"$'\n'" from spotlight" ]]; then
      printf 'Unregistered %s; Spotlight reported -10814, but the Launch Services entry is gone.\n' "$registered_app" >&2
      exit 0
    fi

    printf '%s\n' "$output" >&2
    exit "$status"
  '';
in
{
  options.targets.darwin.launchServices.scripts = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    internal = true;
    readOnly = true;
    default = { inherit launchServiceApps unregisterApp; };
    description = "Shared helpers for Home Manager and nix-darwin app registration.";
  };

  config.home.activation.registerHMApps =
    lib.hm.dag.entryAfter
      (
        [ "linkGeneration" ] ++ lib.optionals config.targets.darwin.mac-app-util.enable [ "trampolineApps" ]
      )
      ''
        # Trampolines must be created before unregistering them.
        echo "Unregistering managed app trampolines with Launch Services..."
        for app in /Applications/Nix\ Trampolines/*.app "$HOME"/Applications/Home\ Manager\ Trampolines/*.app; do
          [ -e "$app" ] || continue
          run ${unregisterApp} ${launchServiceApps} "$app"
        done

        echo "Registering current managed apps with Launch Services..."
        for app in /Applications/Nix\ Apps/*.app "$HOME"/Applications/Home\ Manager\ Apps/*.app; do
          [ -e "$app" ] || continue
          current_app=$(${pkgs.coreutils}/bin/readlink -f "$app")
          # Updating one registration does not remove old store copies with the same bundle ID.
          stale_apps=$(/usr/bin/osascript -l JavaScript ${launchServiceApps} stale "$current_app")
          while IFS= read -r stale_app; do
            [ -n "$stale_app" ] || continue
            run ${unregisterApp} ${launchServiceApps} "$stale_app"
          done <<< "$stale_apps"
          run ${lsregister} -f "$current_app"
        done
      '';
}
