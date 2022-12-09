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
        extraConfig = ''
          set theme=(hd1,gpt6)/${pkgs.fetchzip {
            url = "https://raw.githubusercontent.com/AdisonCavani/distro-grub-themes/master/themes/asus.tar";
            sha256 = "sha256-+yol6dzvaQ/ItlegTHJREqkUNGoJl4t66qEA0QPUDiw=";
            stripRoot = false;
          }}/theme.txt
        '';
      };
    };

    plymouth = {
      enable = true;
      themePackages = [pkgs.adi1090x-plymouth];
      theme = "colorful_loop";
    };

    kernelParams = ["module_blacklist=i915"];
    kernelPackages = pkgs.linuxPackages_zen;
    extraModprobeConfig = "options hid_apple fnmode=2";
  };

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;

    fonts = with pkgs; [
      inter
      nerdfonts
      noto-fonts-cjk-sans
      recursive
      rubik
      twemoji-color-font
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts = {
        monospace = ["Maple Mono NF"];
        sansSerif = ["Google Sans Text"];
      };
      hinting.style = "hintfull";
    };
  };

  networking = {
    hostName = "nix";
    useDHCP = false;

    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    mullvad-vpn.enable = true;

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    pipewire = {
      enable = true;
      jack.enable = true;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];

      displayManager.sddm = {
        enable = true;
      };
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    steam.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland-nvidia;
    };
  };

  environment = {
    variables = {
      CLUTTER_BACKEND = "wayland";
      DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
      GBM_BACKEND = "nvidia-drm";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      WLR_BACKEND = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(ssh-agent)
      eval $(gnome-keyring-daemon --start)
    '';
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  i18n = {
    inputMethod.enabled = "ibus";
    inputMethod.ibus.engines = with pkgs.ibus-engines; [uniemoji];

    extraLocaleSettings = {
      LC_TIME = "en_US.UTF-8";
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  documentation.man.man-db.enable = false;

  nix.settings.trusted-users = ["root" "marshall"];

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
