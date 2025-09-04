{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.activation.registerHMApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Regenerating LaunchService Database..."

    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -seed -r -domain local -domain system -domain user

    /usr/bin/killall Dock || true
    /usr/bin/killall Finder || true

    echo "Unregistering Nix Darwin Trampolines with LaunchService..."

    for app in /Applications/Nix\ Trampolines/*.app; do
      [ -e "$app" ] || continue

      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "$app"
    done

    echo "Registering Nix Darwin Apps with LaunchService..."

    for app in /Applications/Nix\ Apps/*.app; do
      [ -e "$app" ] || continue

      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
    done

    echo "Unregistering Home Manager Trampolines with LaunchService..."

    for app in ~/Applications/Home\ Manager\ Trampolines/*.app; do
      [ -e "$app" ] || continue

      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "$app"
    done

    echo "Registering Home Manager Apps with LaunchService..."

    for app in ~/Applications/Home\ Manager\ Apps/*.app; do
      [ -e "$app" ] || continue

      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
    done
  '';
}
