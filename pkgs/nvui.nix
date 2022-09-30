{
  stdenv,
  mkDerivation,
  cmake,
  pkg-config,
  msgpack,
  fmt,
  boost,
  fetchFromGitHub,
  wrapQtAppsHook
}:
mkDerivation rec {
  pname = "nvuiFIXME";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rohit-px2";
    repo = "nvui";
    rev = "568e9cb17970c56cee8909ac4f39ea7ab52bc46a";
    hash = "sha256-B7q+dNQkfaEdFhC9buvvnoao4cx4n8AoRl5Qx20svhI=";
  };

  qtWrapperArgs = "--add-flags \"--detached --\"";

  buildInputs = [
    msgpack
    fmt
    boost
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nvui/bin
    mkdir -p $out/bin
    cp ./nvui $out/bin/
    cp -r $src/vim $out/share/nvui/vim
    cp -r $src/assets $out/share/nvui/assets
    chmod +x $out/bin/nvui

    runHook postInstall
  '';
}
