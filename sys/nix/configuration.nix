{ inputs
, config
, pkgs
, ...
}: {
  disabledModules = [ "services/hardware/udev.nix" ];
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
    # kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages =
      let
        linux_six_pkg =
          { fetchurl
          , buildLinux
          , ...
          } @ args:
          buildLinux (args
            // rec {
            version = "6.0.0-rc1";
            modDirVersion = version;
            src = fetchurl {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/linux-master.tar.gz";
              sha256 = "b7273835119dced6d9b5f9378ea43da275968e1142c78c3e3e3484c57b0b7cdd";
            };

            kernelPatches = [ ];

            extraMeta.branch = "master";
          }
            // (args.argsOverride or { }));
        linux_six = pkgs.callPackage linux_six_pkg { };
      in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_six);
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

  environment.systemPackages = [ pkgs.mySddmTheme ];
  services = {
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    kmscon = {
      enable = false;
      fonts = [
        {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerdfonts;
        }
      ];
      extraConfig = ''
        no-drm
      '';
    };
    flatpak.enable = true;
    mullvad-vpn.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        sddm = {
          enable = true;
          theme = "aerial-sddm-theme";
        };
        defaultSession = "hyprland";
      };

      windowManager.awesome.enable = true;

      videoDrivers = [ "nvidia" ];
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

  programs.gamemode.enable = true;

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
      package =
        let
          p = config.boot.kernelPackages.nvidia_x11;
        in
        rec {
          open = p.open.overrideAttrs (old: { });
          bin = open;
          out = open.out;
          inherit (p) settings useProfiles;
          type = "derivation";
        };
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    i2c.enable = true;
  };

  nix.settings.trusted-users = [ "root" "marshall" ];

  xdg.portal.enable = true;

  system.stateVersion = "21.11";
}
