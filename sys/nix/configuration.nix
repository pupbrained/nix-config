# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{

  imports = [ ./hardware-configuration.nix ../generic.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_testing;
    extraModprobeConfig = "options hid_apple fnmode=1";
  };

  networking = {
    hostName = "nix";
    useDHCP = false;
    networkmanager.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };
        defaultSession = "none+awesome";
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        extraPackages = with pkgs; [ feh polybar i3lock ];
      };

      windowManager.awesome.enable = true;

      videoDrivers = [ "nvidia" ];
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  hardware = {
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
