{
  inputs,
  pkgs,
  lib,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [(import ../pkgs inputs)];
  };

  nix = {
    package = pkgs.nixVersions.unstable;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;

      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org"
        "https://fortuneteller2k.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://helix.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      trusted-users = ["marshall"];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      extra-sandbox-paths = /nix/var/cache/ccache
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  systemd = {
    user.services.pipewire-pulse.path = [pkgs.pulseaudio];

    services = {
      openssh.enable = true;
      NetworkManager-wait-online.enable = false;

      ssh-agent = {
        enable = true;
        description = "SSH key agent";

        serviceConfig = {
          Type = "simple";
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
          ExecStart = "/run/current-system/sw/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
        };

        wantedBy = ["multi-user.target"];
      };
    };
  };

  users.users.marshall = {
    isNormalUser = true;
    home = "/home/marshall";
    shell = pkgs.nushell;

    extraGroups = [
      "asbusers"
      "i2c"
      "networkmanager"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA12eoS+C+n1Pa1XaygSmx4+CGkO6oYV5bZeSeBU28Y mars@possums.xyz"
    ];
  };

  system.activationScripts = {
    fixVsCodeWriteAsSudo = {
      text = ''
        mkdir -m 0755 -p /bin
        ln -sf "/run/current-system/sw/bin/bash" /bin/.bash.tmp
        mv /bin/.bash.tmp /bin/bash
        ln -sf "/run/wrappers/bin/pkexec" /usr/bin/.pkexec.tmp
        mv /usr/bin/.pkexec.tmp /usr/bin/pkexec
        eval $(/run/current-system/sw/bin/ssh-agent)
      '';
      deps = [];
    };
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  programs = {
    ccache.enable = true;
    command-not-found.enable = false;
  };

  time.timeZone = "America/New_York";
  security.sudo.wheelNeedsPassword = false;
}
