{
  pkgs,
  stdenv,
  fetchFromGitHub,
  papirus-icon-theme,
}:
stdenv.mkDerivation {
  pname = "catppuccin-folders";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "papirus-folders";
    rev = "6f8292748e508373dea59cb7dacc0ddc3c6b287d";
    sha256 = "sha256-LVMl33DGT6WwVbIXWmWox0Dp9pcRRniSQI8sq27JaAI=";
  };

  buildInputs = with pkgs; [getent];

  installPhase = ''
    mkdir -p $out/share/icons/Papirus
    cp -r ${papirus-icon-theme}/share/icons/Papirus $out/share/icons
    chmod -R u+rw $out
    cp -r src/* $out/share/icons/Papirus
    bash ./papirus-folders -C cat-mocha-green --theme $out/share/icons/Papirus -o
  '';
}
