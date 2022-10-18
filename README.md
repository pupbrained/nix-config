# nix-config<br><br><sup>My personal NixOS configuration</sup>

This repository is used to hold my configuration for NixOS on my main daily driver. It is a flake-based configuration, with the entry point being `flake.nix`.

## Structure

```
.
├── bin         # Scripts for updating/building config
├── dotfiles    # Application-related configurations
├── home        # Home-manager configuration
├── pkgs        # Package expressions & overlays
├── secrets     # Secret files
└── sys         # System configuration
```
