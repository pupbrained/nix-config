{
  stdenv,
  lib,
  web-greeter-src,
  nodejs,
  rsync,
  pkg-config,
  python3Packages,
  python3,
  gobject-introspection,
  lightdm,
  xorg,
  libsForQt5,
  wrapGAppsHook,
  callPackage,
}: let
  myPython = python3.withPackages (p:
    with p; [
      pygobject3
      pyqt5
      pyqtwebengine
      ruamel_yaml
      pyinotify
    ]);
in
  stdenv.mkDerivation
  {
    pname = "web-greeter";
    version = web-greeter-src.rev;
    src = web-greeter-src;
    dontWrapQtApps = true;
    nativeBuildInputs = [nodejs rsync pkg-config python3Packages.pyqt5];
    buildInputs = [
      lightdm
      gobject-introspection
      xorg.libX11
      libsForQt5.qtwebengine
      wrapGAppsHook
    ];
    propagatedBuildInputs = [
      lightdm
      gobject-introspection
    ];
    __noChroot = true;
    buildPhase = ''
      sed -i 's/python3/${lib.strings.escape ["/"] (toString myPython)}\/bin\/python3/g' Makefile

      HOME=$(mktemp -d)
      # fuck it
      npm exec --package=typescript -- make
    '';
    installPhase = ''
      make install
    '';
    DESTDIR = placeholder "out";
    PREFIX = "/";
  }
