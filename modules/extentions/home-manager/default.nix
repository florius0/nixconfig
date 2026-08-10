# Home Manager extension entry point. Implementations in this directory are
# imported automatically and are kept separate from end-user home declarations.
{
  imports =
    with builtins;
    map (fn: ./${fn}) (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
}
