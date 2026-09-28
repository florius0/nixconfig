{ config, ... }:

{
  environment.etc."codex/config.toml".source =
    config.home-manager.users.${config.system.primaryUser}.home.file.".codex/config.toml".source;
}
