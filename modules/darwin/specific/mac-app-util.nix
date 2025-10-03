# modules/darwin/specific/mac-app-util.nix
{ flake, ... }:

let
  inherit (flake) inputs;
in
{
  imports = [ inputs.mac-app-util.darwinModules.default ];

  home-manager.sharedModules = [
    flake.inputs.mac-app-util.homeManagerModules.default
  ];
}
