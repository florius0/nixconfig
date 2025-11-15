{ ... }:

{
  # Nix installation is managed by Determinate
  nix.enable = false;

  nix.gc = {
    automatic = false;
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
