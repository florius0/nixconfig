# TODO: Delete when direnv/fish updates
final: prev: {
  fish = prev.fish.overrideAttrs (_: {
    doCheck = false;
  });
}
