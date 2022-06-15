{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ../generic.nix];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
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

  environment.systemPackages = [pkgs.mySddmTheme];
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        sddm = {
          enable = true;
          theme = "aerial-sddm-theme";
        };
        defaultSession = "none+awesome";
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        extraPackages = with pkgs; [feh polybar i3lock];
      };

      windowManager.awesome.enable = true;

      videoDrivers = ["nvidia"];
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

  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
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
