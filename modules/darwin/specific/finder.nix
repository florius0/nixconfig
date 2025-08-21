{ ... }:

{
  # Extensions everywhere
  system.defaults.NSGlobalDomain = {
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;
    ApplePressAndHoldEnabled = false;
  };

  # Finder
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    # Search current folder
    FXDefaultSearchScope = "SCcf";
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "Nlsv";
    NewWindowTarget = "Documents";
    ShowPathbar = true;
    _FXSortFoldersFirst = true;
    _FXSortFoldersFirstOnDesktop = true;
  };

  # Stacks on Desktop
  system.defaults.CustomUserPreferences."com.apple.finder".DesktopViewSettings = {
    GroupBy = "Kind";
    IconViewSettings.arrangeBy = "dateAdded";
  };

}
