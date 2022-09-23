{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  which,
  nodejs,
  mkYarnPackage,
  fetchYarnDeps,
  python3,
  nixosTests,
}:
mkYarnPackage rec {
  pname = "upscayl";
  version = "1.5.0";

  src = fetchzip {
    url = "https://github.com/hedgedoc/hedgedoc/releases/download/${version}/hedgedoc-${version}.tar.gz";
    hash = "sha256-YBPxL1/2bj+8cemSBZSNqSlD/DYJRxSG5UuyUipf3R8=";
  };

  nativeBuildInputs = [which makeWrapper];
  extraBuildInputs = [python3];

  packageJSON = ./package.json;
  yarnFlags = ["--production"];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-tnxubtu2lv5DKYY4rwQzNwvsFu3pD3NF4VUN/xieqpc=";
  };

  dontInstall = true;

  meta = with lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://hedgedoc.org";
    maintainers = with maintainers; [willibutz SuperSandro2000];
    platforms = platforms.linux;
  };
}
