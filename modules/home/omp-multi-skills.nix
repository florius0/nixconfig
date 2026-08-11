{ flake, pkgs, ... }:

{
  home.file.".omp/agent/extensions/multi-skills" = {
    source = flake.self.packages.${pkgs.stdenv.hostPlatform.system}.omp-multi-skills;
    recursive = true;
  };
}
