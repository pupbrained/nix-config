{
  inputs,
  pkgs,
  config,
  ...
}:
with pkgs; {
  imports = [
    ../pkgs/neovim
    ../pkgs/nushell
  ];

  home.packages = [
    draconis
    starship
    ripgrep
    rustup
    gcc
    gnumake
    riff
  ];
}
