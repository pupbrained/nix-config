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
    # startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  system.stateVersion = "22.05";
}
