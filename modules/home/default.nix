# A module that automatically imports everything else in the parent folder.
{
  imports =
    with builtins;
    [ ../extentions/home-manager ]
    ++ map (fn: ./${fn}) (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
}
