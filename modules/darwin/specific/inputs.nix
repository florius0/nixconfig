{ ... }:

{
  # Mouse/Trackpad
  system.defaults.NSGlobalDomain = {
    "com.apple.mouse.tapBehavior" = 1;
    "com.apple.swipescrolldirection" = true;
    "com.apple.trackpad.enableSecondaryClick" = true;
    "com.apple.trackpad.forceClick" = false;
    "com.apple.trackpad.scaling" = 1.5;
  };
  system.defaults.trackpad = {
    Clicking = true;
    FirstClickThreshold = 0;
  };

  # Keyboard
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };

  # Set FN to do nothing
  system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";

  # Typing
  system.defaults.NSGlobalDomain = {
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticInlinePredictionEnabled = true;
  };

}
