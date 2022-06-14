#!/usr/bin/env bash
set -eo pipefail

nix run nixpkgs#alejandra -- . -q

for i in $(nix profile list | cut -d' ' -f1); do
  nix profile remove 0
done

nix-shell -p git --run "nixos-rebuild switch --flake .# --use-remote-sudo"

sudo systemctl restart home-manager-marshall
