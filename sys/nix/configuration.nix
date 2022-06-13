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
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
  };

  environment.systemPackages =
    let
      inherit (pkgs) plasma5Packages;
      sddm_theme = plasma5Packages.mkDerivation {
        name = "sddm-theme";
        src = ./sugar-candy.tar.gz;
        propagatedUserEnvPkgs = with plasma5Packages; [ qtgraphicaleffects ];
        installPhase = ''
          mkdir -p $out/share/sddm/themes
          cp -r ./. $out/share/sddm/themes/sugar-candy
          cp ${./sugar-candy.conf} $out/share/sddm/themes/sugar-candy/theme.conf
        '';
      };
    in
    [ sddm_theme ];
  services = {
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        sddm = {
          enable = true;
          theme = "sugar-candy";
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

  environment.loginShellInit = ''
    dbus-update-activation-environment --systemd DISPLAY
    eval $(ssh-agent)
    eval $(gnome-keyring-daemon --start)
    export GPG_TTY=$TTY
  '';

  security.pam.services.sddm.enableGnomeKeyring = true;
  powerManagement.cpuFreqGovernor = "performance";

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
