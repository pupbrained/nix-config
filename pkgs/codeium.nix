{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  name = "codeium";
  src = pkgs.fetchurl {
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-v1.2.76/language_server_linux_arm";
    sha256 = "sha256-/xJSzrYS8ycGegzH+MmhqJMGnQtJMtUjVfUNVqxSVzM=";
  };
  nativeBuildInputs = [pkgs.autoPatchelfHook];
  unpackPhase = "true";
  installPhase = ''
    ls -lR $src
    mkdir -p $out/bin
    cp $src $out/bin/language_server_linux_arm
    chmod +x $out/bin/language_server_linux_arm
  '';
}
