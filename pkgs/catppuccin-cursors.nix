{
  lib,
  stdenv,
  fetchzip,
  makeFontsConf,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-cursors";
  version = "unstable";

  src = fetchzip {
    url = "https://github.com/catppuccin/cursors/raw/main/cursors/Catppuccin-Mocha-Dark-Cursors.zip";
    sha256 = "sha256-I/QSk9mXrijf3LBs93XotbxIwe0xNu5xbtADIuGMDz8=";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    install -dm 0755 $out/share/icons/Catppuccin-Mocha-Dark-Cursors
    cp -r $src/cursors $out/share/icons/Catppuccin-Mocha-Dark-Cursors/cursors
    cp -r $src/index.theme $out/share/icons/Catppuccin-Mocha-Dark-Cursors/index.theme
  '';
}
