#!/usr/bin/env bash
set -eo pipefail

nix build .#hmConfig.marshall.activationPackage
./result/activate
sudo nixos-rebuild switch --flake .#
