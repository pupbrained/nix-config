{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.unstable;

    gc = {
      automatic = true;
      interval = {
        Day = 7;
      };
    };

    daemonProcessType = "idle";

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
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://fortuneteller2k.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://helix.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-substituters = [
        "cache.nixos.org"
        "nix-community.cachix.org"
        "fortuneteller2k.cachix.org"
        "nixpkgs-wayland.cachix.org"
        "helix.cachix.org"
        "hyprland.cachix.org"
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

  nixpkgs.config.allowUnfree = true;

  users.users.marshall = {
    name = "marshall";
    home = "/Users/marshall";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.marshall = {pkgs, ...}: {
      imports = [./home.nix];
    };
  };
}
