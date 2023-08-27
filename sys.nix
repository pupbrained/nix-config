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
      (_: _: {
        inherit
          (inputs.nixpkgs-stable.legacyPackages.aarch64-linux)
          webkitgkt
          webkitgtk_4_1
          webkitgtk_6_0
          ;
      })
    ];

    config = {allowUnfree = true;};
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
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

      extraGroups = ["wheel" "networkmanager" "audio"];
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

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.fish.enable = true;

  system.stateVersion = "23.11";
  time.timeZone = "America/New_York";
}
