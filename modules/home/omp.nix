{
  flake,
  lib,
  pkgs,
  ...
}:
let
  omp = flake.inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.omp;
in
{
  # Keep OMP's config writable and preserve settings managed by its UI.
  home.activation.configureOmpTitles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${omp}/bin/omp config set title.icons emoji
  '';
}
