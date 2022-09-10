{
  stdenv,
  electron,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  fetchurl,
  libX11,
  libXrandr,
  libXcomposite,
  libXdamage,
  glib,
  libGL,
  libxkbcommon,
  libdrm,
  nss,
  atk,
  at-spi2-atk,
  gtk3,
  mesa,
  alsa-lib,
}:
  stdenv.mkDerivation rec {
    pname = "Revolt";
    version = "1.0.6";
    src = fetchurl {
      url = "https://github.com/revoltchat/desktop/releases/download/v${version}/Revolt-linux.tar.gz";
      sha256 = "sha256-AG3RrpYkMgrUd3hOrlLhpdORGCX9Dl/1rh6zYg7VSN0=";
    };

    dontBuild = true;
    dontStrip = true;

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = "revolt-desktop";
        comment = "User-first, privacy focused chat platform.";
        desktopName = "Revolt";
      })
    ];

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];
    buildInputs = [
      electron
      
      libX11
      libXcomposite
      libXrandr
      libXdamage
      glib
      libxkbcommon
      libdrm
      nss
      atk
      at-spi2-atk
      gtk3
      libGL
      mesa
      alsa-lib
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/revolt $out/share/revolt $out/share/pixmaps
      cp -r ./ $out/opt/revolt
      mv $out/opt/revolt/{locales,resources} $out/share/revolt

      makeWrapper ${electron}/bin/electron $out/bin/revolt-desktop \
        --add-flags $out/share/revolt/resources/app.asar

      runHook postInstall
    '';
  }
