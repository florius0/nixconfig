{ config, ... }:

{
  home.file."${config.me.applicationSupport}/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
