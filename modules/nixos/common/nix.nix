{ ... }:

{
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
