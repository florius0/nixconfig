# A module that automatically imports everything else in the parent folder.
{
  imports = [
    ../extentions/home
  ]
  ++ map (fn: ./${fn}) (
    builtins.filter (fn: fn != "default.nix") (builtins.attrNames (builtins.readDir ./.))
  );
}
