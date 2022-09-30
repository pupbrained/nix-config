{
  stdenv,
  cmake,
  ninja,
  pkg-config,
  msgpack,
  qt5Full,
  fmt,
  boost,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "nvui";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rohit-px2";
    repo = "nvui";
    rev = "568e9cb17970c56cee8909ac4f39ea7ab52bc46a";
    hash = "sha256-B7q+dNQkfaEdFhC9buvvnoao4cx4n8AoRl5Qx20svhI=";
  };

  buildInputs = [
    msgpack
    qt5Full
    fmt
    boost
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  installPhase = ''
    mkdir -p $out/share/nvui/bin
    mkdir -p $out/bin
    cp ./nvui $out/share/nvui/bin
    cp -r $src/vim $out/share/nvui/vim
    cp -r $src/assets $out/share/nvui/assets
    echo -e '#!/bin/bash\n\n${placeholder out}/share/nvui/bin/nvui --detached -- "$@"' > $out/bin/nvui
    chmod +x $out/bin/nvui
  '';
}
