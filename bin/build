#!/usr/bin/env bash
set -eo pipefail

nix run nixpkgs#alejandra -- . -q
nix run nixpkgs#statix -- fix .

nix-shell -p git --run "nixos-rebuild switch --flake .# --impure --use-remote-sudo --option sandbox false"
nix run .#update-home
