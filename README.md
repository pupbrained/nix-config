# nix-config
## My personal NixOS configuration

This branch of the repository is used to hold my Nix configuration for macOS. It is a flake-based configuration, with the entry point being `flake.nix`.

## Structure
```
.
├── bin         # Scripts for updating/building config
├── pkgs        # Package expressions & overlays
├── services    # Service-related modules
├── shell.nix   # Nix-shell compatibility
├── sys.nix     # System configuration
└── home.nix    # Home-manager configuration
```
