{
  inputs,
  config,
  pkgs,
  lib,
  self,
  xdg-hyprland,
  ...
}:
with lib; {
  disabledModules = ["services/hardware/udev.nix"];

  imports = [
    "${self}/sys/nix/hardware-configuration.nix"
    "${self}/sys/generic.nix"
    "${self}/sys/patches/udev.nix"
    inputs.lanzaboote.nixosModules.lanzaboote
    # inputs.stylix.nixosModules.stylix
  ];

  boot = {
    bootspec.enable = true;
    kernelParams = ["module_blacklist=i915"];
    kernelPackages = pkgs.linuxPackages_zen;
    extraModprobeConfig = ''
      options hid_apple fnmode=2
      options kvm_intel nested=1
    '';
    supportedFilesystems = ["btrfs" "ext4" "ntfs" "vfat"];

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      systemd-boot.enable = lib.mkForce false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  console = let
    normal = ["181825" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "BAC2DE"];
    bright = ["1E1E2E" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "A6ADC8"];
  in {
    colors = normal ++ bright;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u18b.psf.gz";
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
      twemoji-color-font
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = ["Maple Mono NF"];
        sansSerif = ["Google Sans Text"];
      };
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
    udev.packages = [pkgs.gnome.gnome-settings-daemon];

    gnome = {
      gnome-keyring.enable = true;
      gnome-browser-connector.enable = true;
      sushi.enable = true;
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
        defaultSession = "gnome";
        sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

        startx.enable = true;
      };
      desktopManager.gnome.enable = true;
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  environment = {
    gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese
        gnome-music
        gnome-terminal
        gedit
        epiphany
        geary
        evince
        gnome-characters
        totem
        tali
        iagno
        hitori
        atomix
        yelp
      ]);

    systemPackages = with pkgs; [sbctl clapper];

    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(ssh-agent)
      eval $(gnome-keyring-daemon --start --daemonize --components=ssh)
    '';

    variables = {
      CLUTTER_BACKEND = "wayland";
      DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
      DIRENV_LOG_FORMAT = "";
      DISABLE_QT5_COMPAT = "0";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      GDK_SCALE = "2";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WINIT_UNIX_BACKEND = "x11";
      WLR_BACKEND = "vulkan";
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      XCURSOR_SIZE = "48";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
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

  # stylix = {
  #   image = "${self}/dotfiles/hypr/wall.png";
  #   polarity = "dark";
  #   targets.vscode.enable = false;
  #   homeManagerIntegration.autoImport = false;
  #
  #   base16Scheme = "${
  #     pkgs.fetchFromGitHub {
  #       owner = "catppuccin";
  #       repo = "base16";
  #       rev = "ca74b4070d6ead4213e92da1273fcc1853de7af8";
  #       hash = "sha256-fZDsmJ+xFjOJDoI+bPki9W7PEI5lT5aGoCYtkatcZ8A=";
  #     }
  #   }/base16/mocha.yaml";
  #
  #   fonts = {
  #     monospace = {
  #       name = "Cartograph CF";
  #       package = pkgs.hello;
  #     };
  #
  #     sansSerif = {
  #       name = "Rubik";
  #       package = pkgs.rubik;
  #     };
  #
  #     serif = {
  #       name = "Rubik";
  #       package = pkgs.rubik;
  #     };
  #
  #     emoji = {
  #       name = "Twemoji";
  #       package = pkgs.twemoji-color-font;
  #     };
  #   };
  # };

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

    video.hidpi.enable = true;

    i2c.enable = true;
    pulseaudio.enable = false;
  };

  documentation = {
    enable = true;
    doc.enable = true;
    dev.enable = true;
    man = {
      enable = true;
      man-db.enable = false;
    };
  };

  xdg.portal = {
    enable = true;
    # extraPortals = [xdg-hyprland.packages.${pkgs.system}.default];
  };

  nix.settings.trusted-users = ["root" "marshall"];
  system.stateVersion = "21.11";
  time.hardwareClockInLocalTime = true;
  zramSwap.enable = true;
}
