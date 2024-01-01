{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = with inputs; [
    ./hardware.nix

    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    lanzaboote.nixosModules.lanzaboote
  ];

  nixpkgs.config.allowUnfree = true;
  sound.enable = true;
  system.stateVersion = "23.11";
  time.timeZone = "America/New_York";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.marshall = import ./home.nix;
  };

  nix = {
    nixPath = ["nixpkgs=flake:nixpkgs"];
    package = inputs.nix-super.packages.${pkgs.system}.nix;
    registry =
      (lib.mapAttrs (_: flake: {inherit flake;}))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };

  environment = {
    localBinInPath = true;

    sessionVariables = {
      FLAKE = "/home/marshall/nix-config";
      NIXOS_OZONE_WL = "1";
      PATH = ["/home/marshall/.cargo/bin"];
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    persistence."/persist".directories = [
      "/etc/nixos"
      "/etc/NetworkManager"
      "/etc/secureboot"
    ];

    etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
  };

  fonts.packages = with pkgs; [
    inter
    maple-mono-SC-NF
    nerdfonts
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = ["module_blacklist=i915"];
    supportedFilesystems = ["ntfs"];

    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    initrd = {
      enable = true;
      supportedFilesystems = ["btrfs"];

      systemd.services.restore-root = {
        description = "Rollback btrfs rootfs";
        wantedBy = ["initrd.target"];
        requires = ["dev-nvme1n1p3"];
        after = ["dev-nvme1n1p3"];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";

        script = ''
          mkdir -p /mnt

          mount -o subvol=/ /dev/nvme1n1p3 /mnt

          btrfs subvolume list -o /mnt/root |
          	cut -f9 -d' ' |
          	while read subvolume; do
          		echo "deleting /$subvolume subvolume..."
          		btrfs subvolume delete "/mnt/$subvolume"
          	done &&
          	echo "deleting /root subvolume..." &&
          	btrfs subvolume delete /mnt/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          umount /mnt        '';
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/persist/etc/secureboot";
    };

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/".options = ["compress=zstd" "noatime"];
    "/home".options = ["compress=zstd" "noatime"];
    "/nix".options = ["compress=zstd" "noatime"];

    "/persist" = {
      options = ["compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/var/log" = {
      options = ["compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };

  hardware = {
    pulseaudio.enable = false;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        libGL
        libGLU
      ];
      setLdLibraryPath = true;
    };
  };

  networking = {
    hostName = "navis";
    networkmanager.enable = true;
    useDHCP = false;
  };

  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;

    sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };

  programs = {
    fish.enable = true;
    gnupg.agent.enable = true;
    nm-applet.enable = true;
    ssh.startAgent = true;
    steam.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  services = {
    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      layout = "us";
      videoDrivers = ["nvidia"];
      xkbVariant = "";
    };
  };

  users.users.marshall = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvbegZw+6NSR32YccrqLFXZoahP7o33gtnH0oNbDYSD"];
    extraGroups = ["wheel" "networkmanager"];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  virtualisation.podman = {
    enable = true;
    enableNvidia = true;
  };
}
