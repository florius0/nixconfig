{ flake, config, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  me = {
    username = "vadimtsvetkov";
    fullname = "Vadim Tsvetkov";
    email = "vadim.tsvetkov80@gmail.com";
  };

  home.stateVersion = "24.11";
}
