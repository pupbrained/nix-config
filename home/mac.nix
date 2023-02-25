{
  inputs,
  pkgs,
  config,
  ...
}:
with pkgs; {
  imports = [
    ../pkgs/nixvim.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = [
    alejandra
  ];

  home.stateVersion = "23.05";
}
