{
  inputs,
  config,
  pkgs,
  lib,
  self,
  ...
}:
with lib; {
  disabledModules = ["services/hardware/udev.nix"];

  imports = [
    "${self}/sys/nix/hardware-configuration.nix"
    "${self}/sys/generic.nix"
    "${self}/sys/patches/udev.nix"
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
        gfxmodeEfi = "1920x1080";

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

  console = let
    normal = ["181825" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "BAC2DE"];
    bright = ["1E1E2E" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "A6ADC8"];
  in {
    colors = normal ++ bright;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u20b.psf.gz";
    keyMap = "us";
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
      sf-mono-liga
      twemoji-color-font
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      allowBitmaps = true;

      defaultFonts = {
        monospace = ["Maple Mono NF"];
        sansSerif = ["Google Sans Text"];
      };

      hinting = {
        enable = true;
        autohint = true;
        style = "hintfull";
      };

      subpixel.lcdfilter = "default";
    };
  };

  networking = {
    hostName = "nix";
    useDHCP = false;

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
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

      displayManager = {
        defaultSession = "hyprland";
        sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

        sddm = {
          enable = true;
          theme = "dexy-theme";
        };
      };
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  environment = {
    variables = {
      CLUTTER_BACKEND = "wayland";
      DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
      DIRENV_LOG_FORMAT = "";
      DISABLE_QT5_COMPAT = "0";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WINIT_UNIX_BACKEND = "x11";
      WLR_BACKEND = "vulkan";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(ssh-agent)
      eval $(gnome-keyring-daemon --start --daemonize --components=ssh)
    '';

    systemPackages = [pkgs.sddm-dexy-theme];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services = {
      sddm.enableGnomeKeyring = true;
      swaylock.text = ''
        auth include login
      '';
    };
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
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      powerManagement.enable = true;
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

    enableRedistributableFirmware = true;
    i2c.enable = true;
    pulseaudio.enable = false;
  };

  documentation = {
    enable = true;
    doc.enable = false;
    dev.enable = false;
    man = {
      enable = true;
      man-db.enable = false;
    };
  };

  nix.settings.trusted-users = ["root" "marshall"];

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.stateVersion = "21.11";
}
