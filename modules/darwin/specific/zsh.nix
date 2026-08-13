{ ... }:

{
  # Home Manager already initializes completion; skip nix-darwin's duplicate
  # /etc/zshrc compinit, which delays every interactive login shell.
  environment.variables.NOSYSZSHRC = "1";

  # Enable zsh autosuggestions for all packages
  environment.pathsToLink = [ "/share/zsh" ];
}
