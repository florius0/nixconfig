{ flake, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowInsecure = false;
    };

    overlays = # Apply each overlay found in the /overlays directory
      let
        path = ../../../overlays_;
      in
      with builtins;
      map (n: import (path + ("/" + n))) (
        filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
          attrNames (readDir path)
        )
      );
  };
}
