{
  stdenv,
  web-greeter-src,
  nodejs,
  rsync,
  pkg-config,
  python3Packages,
  gobject-introspection,
  lightdm,
  xorg,
  libsForQt5,
  callPackage,
}:
stdenv.mkDerivation {
  pname = "web-greeter";
  version = web-greeter-src.rev;
  src = web-greeter-src;
  dontWrapQtApps = true;
  nativeBuildInputs = [nodejs rsync pkg-config python3Packages.pyqt5];
  buildInputs = with python3Packages; [lightdm pygobject3 pyqt5 pyqtwebengine ruamel_yaml pyinotify gobject-introspection xorg.libX11 libsForQt5.qtwebengine];
  __noChroot = true;
  buildPhase = ''
    HOME=$(mktemp -d)
    # fuck it
    npm exec --package=typescript -- make
  '';
  installPhase = ''
    make install
  '';
  DESTDIR = placeholder "out";
}
