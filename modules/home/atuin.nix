{ lib, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    package = pkgs.atuin.overrideAttrs (old: {
      # These Pi integration tests require process visibility outside the Darwin build sandbox.
      checkFlags =
        (old.checkFlags or [ ])
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          "--skip=a_diverged_copy_resumes_only_as_chosen::agent_4_Agent__Pi"
          "--skip=a_session_gone_on_with_elsewhere_catches_up_where_it_came_from::agent_3_Agent__Pi"
        ];
    });
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];

    settings.ai.enabled = false;
  };
}
