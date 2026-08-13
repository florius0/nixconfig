{ config, ... }:

{
  # Nushell warns when XDG_CONFIG_HOME/nushell is absent or empty.
  home.file."${config.me.xdg.config}/nushell/config.nu".text = "";
}
