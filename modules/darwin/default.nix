{ ... }:

{
  imports = [
    ../nixos/common/nixpkgs.nix
  ]
  ++ map (fn: ./${fn}) (with builtins; filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
}
