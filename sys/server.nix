{
  inputs,
  pkgs,
  ...
}: {
  imports = [./generic.nix];

  system.stateVersion = "23.05";
}
