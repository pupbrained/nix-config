#!/usr/bin/env bash
set -eo pipefail

nixos-rebuild switch --flake .# --use-remote-sudo
