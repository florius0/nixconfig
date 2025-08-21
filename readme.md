# NixConfig

nix home-manager + nix-darwin/nixos via nixos-unified configuration to fully manage my devices.

Built on top of https://github.com/juspay/nixos-unified-template with removal of some features I consider redundant.

## Operating the Configuration

1. `nix run .#apply` to apply the configuration
2. `nix run .#update` to update the dependencies
