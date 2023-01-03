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
    # SNOW BEGIN
    draconis
    starship
    ripgrep
    rustup
    gcc
    gnumake
    riff
    nodePackages.pnpm
    openvscode-server
    starfetch
    # SNOW END
  ];

  services.gpg-agent.pinentryFlavor = "tty";
}
