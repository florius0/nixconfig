{ config, ... }:

{
  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.me.xdg.config}";
    XDG_DATA_HOME = "${config.me.xdg.data}";
    XDG_STATE_HOME = "${config.me.xdg.state}";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];
}
