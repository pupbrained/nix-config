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
    nodePackages.pnpm
    openvscode-server
  ];

  services.gpg-agent.pinentryFlavor = "tty";
}
