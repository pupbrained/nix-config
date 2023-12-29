{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [./services/yabai.nix];

  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;

  networking = {
    computerName = "MacBook Air";
    hostName = "canis";
  };

  environment.variables = {
    EDITOR = "nvim";
    FLAKE = "/Users/marshall/nix-config";
    VISUAL = "nvim";
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      font-awesome
      inter
      maple-mono
      monocraft
      nerdfonts
      victor-mono
    ];
  };

  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
    };

    daemonIOLowPriority = true;
    daemonProcessType = "Adaptive";
    distributedBuilds = true;
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      extra-experimental-features = "nix-command flakes";
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      warn-dirty = false;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-substituters = [
        "cache.nixos.org"
        "nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = ["marshall"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    users.marshall = {...}: {imports = [./home.nix];};
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "apktool"
      "crystal"
      "dune"
      "grep"
      "jj"
      "libiconv"
      "miniupnpc"
      "pam_yubico"
      "pinentry-mac"
      "rustup-init"
      "switchaudio-osx"
    ];

    casks = [
      "alt-tab"
      "apparency"
      "arc"
      "balenaetcher"
      "beaver-notes-arm"
      "datweatherdoe"
      "devtoys"
      "discord-canary"
      "doll"
      "duckduckgo"
      "fig"
      "google-assistant"
      "goneovim"
      "gpg-suite"
      "grammarly-desktop"
      "hiddenbar"
      "httpie"
      "hyper-canary"
      "jetbrains-toolbox" # Imperative IDE installs because of github copilot
      "keka"
      "kitty" # Installed through brew because fig doesn't work well w/ nix version
      "lastfm"
      "latest"
      "launchcontrol"
      "logitech-g-hub"
      "mullvad-browser"
      "neovide"
      "ngrok"
      "notion-enhanced"
      "orion"
      "prismlauncher"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-csv"
      "quicklook-json"
      "quicklookase"
      "raycast"
      "sf-symbols"
      "slimhud"
      "spaceid"
      "steam"
      "suspicious-package"
      "telegram"
      "temurin"
      "tetrio"
      "transmission"
      "ubersicht"
      "unnaturalscrollwheels"
      "utm-beta"
      "vivaldi-snapshot"
      "yubico-authenticator"
      "yubico-yubikey-manager"
      "zerotier-one"
    ];

    taps = [
      "DamascenoRafael/tap"
      "Daniele-rolli/homebrew-beaver"
      "FelixKratz/formulae"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/cask-drivers"
      "homebrew/services"
    ];

    masApps."Kimis - A Client for Misskey" = 1667275125;
  };

  programs = {
    nix-index.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

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

  documentation.enable = false;
}
