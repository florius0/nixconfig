{ config, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = [
      # Editors
      ".vscode"
      ".elixir_ls"
      ".elixir-tools"
      ".lexical"

      # macOS
      # General
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # Linux
      "*.swp"
    ];

    settings = {
      user.name = config.me.username;
      user.email = config.me.email;

      core.autocrlf = "input";
      help.autocorrect = 1;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.followTags = true;
      rebase.autoStash = true;
    };
  };
}
