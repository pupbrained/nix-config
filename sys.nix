{
  inputs,
  pkgs,
  lib,
  ...
}: let
  fenix-complete = pkgs.fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ];
in {
  imports = [
    ./services/yabai.nix
  ];

  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;

  networking = {
    computerName = "MacBook Air";
    hostName = "canis";
  };

  environment = {
    systemPackages = with pkgs; [
      fenix-complete
      rust-analyzer-nightly
    ];

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [font-awesome];
  };

  nix = {
    package = pkgs.nixVersions.unstable;

    gc = {
      automatic = true;
      interval.Day = 7;
    };

    daemonIOLowPriority = true;
    daemonProcessType = "Adaptive";

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
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};

    users.marshall = {...}: {
      imports = [./home.nix];
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    brews = [
      "apktool"
      "libiconv"
      "iproute2mac"
      "pam_yubico"
      "pinentry-mac"
      "sketchybar"
      "switchaudio-osx"
      "vlang"
    ];

    casks = [
      "apparency"
      "bitwarden"
      "datweatherdoe"
      "dozer"
      "fig"
      "fing"
      "firefox"
      "google-assistant"
      "height"
      "jetbrains-toolbox" # Imperative IDE installs because of github copilot
      "kitty" # Installed through brew because fig doesn't work well w/ nix version
      "maccy"
      "nextcloud"
      "neovide"
      "ngrok"
      "obsidian"
      "prismlauncher"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-csv"
      "quicklook-json"
      "quicklookase"
      "reminders-menubar"
      "sf-symbols"
      "slimhud"
      "spaceid"
      "steam"
      "suspicious-package"
      "telegram-desktop"
      "temurin"
      "tetrio"
      "zerotier-one"
    ];

    taps = [
      "DamascenoRafael/tap"
      "FelixKratz/formulae"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/cask-drivers"
      "homebrew/services"
    ];
  };

  programs = {
    nix-index.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [inputs.fenix.overlays.default];
  };

  system = {
    keyboard.enableKeyMapping = true;

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      dock = {
        autohide = true;
        autohide-delay = 1000.0;
        expose-animation-duration = 0.0;
        orientation = "bottom";
        showhidden = true;
        tilesize = 48;
      };
    };
  };

  users.users.marshall = {
    name = "marshall";
    home = "/Users/marshall";
  };
}
