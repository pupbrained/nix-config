{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
with pkgs; {
  imports = [
    ./hardware.nix
    ./apple-silicon-support

    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = [
      (_: prev: {
        inherit
          (inputs.nixpkgs-stable.legacyPackages.aarch64-linux)
          webkitgkt
          webkitgtk_4_1
          webkitgtk_6_0
          ;

        nix = inputs.nix-dram.packages.${prev.system}.default;
        nixos-option =
          prev.nixos-option.override {nix = prev.nixVersions.nix_2_15;};
      })
    ];

    config = {allowUnfree = true;};
  };

  nix = let
    mappedRegistry = lib.mapAttrs (_: v: {flake = v;}) inputs;
  in {
    registry = mappedRegistry // {default = mappedRegistry.nixpkgs;};

    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    settings = {
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (20 * 1024 * 1024 * 1024)}";

      experimental-features = ["nix-command" "flakes" "recursive-nix" "ca-derivations"];
      auto-optimise-store = true;
      default-flake = "github:NixOS/nixpkgs/nixos-unstable";
      warn-dirty = false;
      builders-use-substitutes = true;
      log-lines = 30;
      max-jobs = "auto";
      sandbox = true;
      http-connections = 0;
      keep-derivations = true;
      keep-outputs = true;
      accept-flake-config = true;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://dram.cachix.org"
      ];

      trusted-substituters = ["cache.nixos.org" "nix-community.cachix.org" "dram.cachix.org"];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "dram.cachix.org-1:baoy1SXpwYdKbqdTbfKGTKauDDeDlHhUpC+QuuILEMY="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };

  networking.hostName = "canis-linux";

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';

    kernelParams = ["apple_dcp.show_notch=1"];
  };

  environment = {
    systemPackages = [inputs.nix-software-center.packages.aarch64-linux.default];
    gnome.excludePackages =
      [gnome-photos gnome-tour]
      ++ (with gnome; [
        cheese
        gnome-music
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
      ]);

    sessionVariables = {NIXOS_OZONE_WL = "1";};
  };

  fonts.packages = [maple-mono-SC-NF];

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "overlay";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.marshall = import ./home.nix;
  };

  users.users = {
    marshall = {
      isNormalUser = true;
      shell = pkgs.fish;

      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];

      extraGroups = ["wheel" "networkmanager" "audio" "uinput"];
    };
  };

  services = {
    flatpak.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "auto";
        };

        charger = {
          governor = "schedutil";
          turbo = "auto";
        };
      };
    };

    udev.packages = [
      (pkgs.writeTextFile {
        name = "battery";
        text = ''
          KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="70"
        '';
        destination = "/etc/udev/rules.d/99-asahi-battery.rules";
      })
    ];

    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    fish.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  system.stateVersion = "23.11";
  time.timeZone = "America/New_York";
}
