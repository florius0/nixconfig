# NixConfig

nix home-manager + nix-darwin/nixos via nixos-unified configuration to fully manage my devices.

Built on top of https://github.com/juspay/nixos-unified-template with removal of some features I consider redundant.

## Operating the Configuration

1. [Install Determinate Nix](https://determinate.systems/nix-installer/)
2. `ENABLE_MASAPPS=1 nix run .#apply` to apply the configuration
3. `nix flake update` to update the dependencies
