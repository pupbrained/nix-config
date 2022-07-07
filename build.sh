#!/usr/bin/env bash
set -eo pipefail

nix run nixpkgs#alejandra -- . -q
nix run nixpkgs#statix -- fix .

nix-shell -p git --run "nixos-rebuild switch --flake .# --use-remote-sudo"

sleep 1

for i in $(nix profile list | cut -d' ' -f1); do
  nix profile remove 0
done

sudo systemctl restart home-manager-marshall
