{ pkgs, ... }:

{
  home.file.".omp/agent/extensions/multi-skills" = {
    source = pkgs.omp-multi-skills;
    recursive = true;
  };
}
