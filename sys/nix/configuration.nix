{
  inputs,
  config,
  pkgs,
  ...
}: {
  disabledModules = ["services/hardware/udev.nix"];
  imports = [
    ./hardware-configuration.nix
    ../generic.nix
    ../patches/udev.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    extraModprobeConfig = "options hid_apple fnmode=1";
  };

  networking = {
    hostName = "nix";
    useDHCP = false;
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
    extraHosts = "192.168.1.237 umbrel.local";
    nameservers = [
      "192.168.1.80"
      "1.1.1.1"
    ];
  };

  environment.systemPackages = [];
  services = {
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    flatpak.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        lightdm = {
          enable = true;
          greeter = {
            enable = true;
            package = pkgs.web-greeter;
            name = "web-greeter";
          };
        };
        defaultSession = "hyprland";
      };

      windowManager.awesome.enable = true;

      videoDrivers = ["nvidia"];
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    tor = {
      enable = true;
      torsocks.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland-nvidia;
  };

  environment.loginShellInit = ''
    dbus-update-activation-environment --systemd DISPLAY
    eval $(ssh-agent)
    eval $(gnome-keyring-daemon --start)
    export GPG_TTY=$TTY
    export WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
    export CLUTTER_BACKEND=wayland
    export XDG_SESSION_TYPE=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export MOZ_ENABLE_WAYLAND=1
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_BACKEND=vulkan
  '';

  security.pam.services.sddm.enableGnomeKeyring = true;
  powerManagement.cpuFreqGovernor = "performance";

  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  hardware = {
    nvidia = {
      package = pkgs.linuxKernel.packages.linux_zen.nvidia_x11;
      open = true;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    i2c.enable = true;
  };

  nix.settings.trusted-users = ["root" "marshall"];

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
