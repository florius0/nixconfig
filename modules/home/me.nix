# modules/home/me.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.me.username;
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  options.me = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Your username as shown by `id -un`";
    };
    fullname = lib.mkOption {
      type = lib.types.str;
      description = "Your full name for use in Git config";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Your email for use in Git config";
    };

    home = lib.mkOption {
      type = lib.types.path;
      description = "The home directory of the user";
      default = homeDir;
    };

    xdg = {
      config = lib.mkOption {
        type = lib.types.path;
        default = "${homeDir}/.config";
        description = "XDG config dir";
      };
      data = lib.mkOption {
        type = lib.types.path;
        default = "${homeDir}/.local/share";
        description = "XDG data dir";
      };
      state = lib.mkOption {
        type = lib.types.path;
        default = "${homeDir}/.local/state";
        description = "XDG state dir";
      };
    };

    applicationSupport = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = if pkgs.stdenv.isDarwin then "${homeDir}/Library/Application Support" else null;
      description = "Application Support dir (macOS only)";
    };
  };

  config = {
    home.username = config.me.username;
    home.homeDirectory = config.me.home;
  };
}
