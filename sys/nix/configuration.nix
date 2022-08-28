{
  inputs,
  config,
  pkgs,
  lib,
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

    kernelPackages = pkgs.recurseIntoAttrs (pkgs.linuxPackages_testing.extend (f: p: {
      nvidia_is_evil = f.callPackage ../../pkgs/nvidia-x11 {};
    }));

    extraModprobeConfig = "options hid_apple fnmode=1";
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
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
    flatpak.enable = true;
    mullvad-vpn.enable = true;

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    xserver = {
      enable = true;

      displayManager = {
        sddm = {
          enable = true;
          theme = "astronaut-sddm-theme";
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

  programs = {
    gamemode.enable = true;
    zsh.enable = true;
    ccache.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland-nvidia;
    };
  };

  environment.loginShellInit = ''
    dbus-update-activation-environment --systemd DISPLAY
    eval $(ssh-agent)
    eval $(gnome-keyring-daemon --start)
    export WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
    export GPG_TTY=$TTY
    export CLUTTER_BACKEND=wayland
    export XDG_SESSION_TYPE=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export MOZ_ENABLE_WAYLAND=1
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_BACKEND=vulkan
    export GTK_THEME=Quixotic-pink
  '';

  security.pam.services.sddm.enableGnomeKeyring = true;
  powerManagement.cpuFreqGovernor = "performance";

  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidia_is_evil.unfucked;
      modesetting.enable = true;
      open = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    i2c.enable = true;
    pulseaudio.enable = false;
  };

  nix.settings.trusted-users = ["root" "marshall"];

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
