# TODO: Delete when werf 2.69.1 tests are fixed on nixpkgs
final: prev: {
  werf = prev.werf.overrideAttrs (_: {
    doCheck = false;
  });
}
