{
  inputs,
  pkgs,
  ...
}: {
  imports = [./generic.nix];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "marshall";
  };

  system.stateVersion = "22.05";
}
