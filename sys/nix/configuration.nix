{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  disabledModules = ["services/hardware/udev.nix"];

  imports = [
    ./hardware-configuration.nix
    ../generic.nix
    ../patches/udev.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        version = 2;
      };
    };

    kernelPackages = let
      linux_six_pkg = {
        fetchurl,
        buildLinux,
        ...
      } @ args:
        buildLinux (args
          // rec {
            version = "6.0-rc5";

            modDirVersion = builtins.replaceStrings ["-"] [".0-"] version;

            src = fetchurl {
              url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
              sha256 = "GELU1ZEOM5gGUJxG54JoiI9qLQXJ2Cd/kyOLcp0AWgc=";
            };

            kernelPatches = [];

            extraMeta.branch = lib.versions.majorMinor version;
          }
          // (args.argsOverride or {}));
      linux_six = pkgs.callPackage linux_six_pkg {};
    in
      pkgs.recurseIntoAttrs ((pkgs.linuxPackagesFor linux_six).extend (f: p: {
        nvidia_is_evil = f.callPackage ../../pkgs/nvidia-x11 {};
      }));

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

  environment.systemPackages = with pkgs; [
    mySddmTheme
  ];

  services = {
    blueman.enable = true;
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
    fish.enable = true;
    ccache.enable = true;
    gamemode.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland-nvidia;
    };
  };

  environment.loginShellInit = ''
    dbus-update-activation-environment --systemd DISPLAY
    eval $(ssh-agent)
    eval $(gnome-keyring-daemon --start)
  '';

  security = {
    pam.services.sddm.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidia_is_evil.unfucked;
      modesetting.enable = true;
      open = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };

    i2c.enable = true;
    pulseaudio.enable = false;
  };

  environment.extraInit = ''
    export LIBVA_DRIVER_NAME="nvidia"
    export GBM_BACKEND="nvidia-drm"
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER="vulkan"
    export WLR_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"
    export GPG_TTY="$TTY"
    CLUTTER_BACKEND="wayland"
    XDG_SESSION_TYPE="wayland"
    QT_QPA_PLATFORM="wayland"
    QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    WLR_BACKEND="vulkan"
    GTK_THEME="Quixotic-pink"
  '';

  documentation.man.man-db.enable = false;

  nix.settings.trusted-users = ["root" "marshall"];

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
