{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.activation.playwrightConfiguration = ''
    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
  '';
}
