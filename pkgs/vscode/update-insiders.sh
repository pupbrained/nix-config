#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/insiders.nix" ]; then
  echo "ERROR: cannot find insiders.nix in $ROOT"
  exit 1
fi

update_vscode() {
  VSCODE_VER=$1
  ARCH=$2
  ARCH_LONG=$3
  VSCODE_URL="https://update.code.visualstudio.com/${VSCODE_VER}/${ARCH}/insider"
  VSCODE_SHA256=$(nix-prefetch-url ${VSCODE_URL})
  sed -i "s/${ARCH_LONG} = \".\{52\}\"/${ARCH_LONG} = \"${VSCODE_SHA256}\"/" \
    "$ROOT/insiders.nix"
}

# VSCode

VSCODE_VER=$(curl --fail --silent https://update.code.visualstudio.com/api/releases/insider |
  jq --raw-output .[0])
sed -i "s/version = \".*\"/version = \"${VSCODE_VER}\"/" "$ROOT/insiders.nix"

update_vscode $VSCODE_VER darwin-arm64 aarch64-darwin
