{ ... }:

{
  home.sessionVariables._ZO_RESOLVE_SYMLINKS = "0";

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
