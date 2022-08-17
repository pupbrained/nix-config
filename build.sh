#!/usr/bin/env bash
set -eo pipefail

nix run nixpkgs#alejandra -- . -q
nix run nixpkgs#statix -- fix .

for i in $(nix profile list | cut -d' ' -f1); do
  nix profile remove 0
done

nix-shell -p git --run "nixos-rebuild switch --flake .# --impure --use-remote-sudo --option sandbox false"

sudo systemctl restart home-manager-marshall
