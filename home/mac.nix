{
  inputs,
  pkgs,
  config,
  ...
}:
with pkgs; {
  imports = [
    ../pkgs/nixvim.nix
    ../pkgs/bat.nix
    ../pkgs/vscode.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = [
    alejandra
    bat
    comma
    ripgrep
    fd
    fzf
  ];

  home.stateVersion = "23.05";
}
