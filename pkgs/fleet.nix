{
  stdenv,
  fetchzip,
  lib,
  alsa-lib,
  glib,
  zlib,
  autoPatchelfHook,
  freetype,
  fontconfig,
  mesa,
  libX11,
  libXext,
  libXrender,
  libXtst,
  libXi,
  libGL,
  makeDesktopItem,
}:
stdenv.mkDerivation rec {
  pname = "jetbrains-fleet";
  version = "1.9.231";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/fleet/installers/linux_x64/Fleet-1.9.231.tar.gz";
    sha256 = "sha256-Z1W8VV4G9u3xZphTs29ikw7sYHSA2xBjSTbTX3eE/oo=";
  };

  sourceRoot = ".";

  dontBuild = true;

  nativeBuildInputs = [autoPatchelfHook zlib freetype libX11 libXext libXrender libXtst libXi alsa-lib glib fontconfig mesa libGL];

  installPhase = ''
    mkdir -p $out/share/icons
    cp $src/lib/Fleet.png $out/share/icons
    cp -r $src/* $out
  '';

  desktopItem = makeDesktopItem {
    name = "jetbrains-fleet";
    exec = "Fleet";
    icon = "Fleet";
    desktopName = "JetBrains Fleet";
    genericName = "JetBrains Fleet";
    categories = ["Development"];
  };
}