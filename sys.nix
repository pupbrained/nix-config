{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {
    computerName = "MacBook Air";
    hostName = "canis";
  };

  environment = {
    systemPackages = with pkgs; [
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
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
      options = "--delete-older-than 7d";
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
      auto-optimise-store = true
      experimental-features = nix-command flakes
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
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
      "spotify"
      "steam"
      "suspicious-package"
      "telegram-desktop"
      "temurin"
      "zerotier-one"
      {
        name = "unofficial-wineskin";
        args.no_quarantine = true;
      }
    ];

    taps = [
      "DamascenoRafael/tap"
      "FelixKratz/formulae"
      "gcenx/wine"
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

  services = {
    nix-daemon.enable = true;

    skhd = {
      enable = true;
      package = pkgs.skhd;

      skhdConfig = ''
        alt - return : open -na "Kitty" ~
        alt - w : open -na "Arc"
        alt - d : scratchpad --toggle discord
        alt - t : scratchpad --toggle telegram

        cmd - space : yabai -m window --toggle float

        shift + cmd - q : yabai -m window --close

        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        shift + cmd - h : yabai -m window --swap west
        shift + cmd - j : yabai -m window --swap south
        shift + cmd - k : yabai -m window --swap north
        shift + cmd - l : yabai -m window --swap east

        shift + cmd - 1 : yabai -m window --space 1
        shift + cmd - 2 : yabai -m window --space 2
        shift + cmd - 3 : yabai -m window --space 3
        shift + cmd - 4 : yabai -m window --space 4
        shift + cmd - 5 : yabai -m window --space 5
        shift + cmd - 6 : yabai -m window --space 6
        shift + cmd - 7 : yabai -m window --space 7
        shift + cmd - 8 : yabai -m window --space 8
        shift + cmd - 9 : yabai -m window --space 9
        shift + cmd - 0 : yabai -m window --space 10
      '';
    };

    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = false;

      config = {
        layout = "bsp";
        top_padding = 20;
        bottom_padding = 20;
        left_padding = 20;
        right_padding = 20;
        window_gap = 20;
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
      };

      extraConfig = ''
        yabai -m rule --add app='^Emacs$' manage=on
        yabai -m rule --add title='Preferences' manage=off layer=above
        yabai -m rule --add title='^(Opening)' manage=off layer=above
        yabai -m rule --add title='Library' manage=off layer=above
        yabai -m rule --add app='^System Preferences$' manage=off layer=above
        yabai -m rule --add app='Activity Monitor' manage=off layer=above
        yabai -m rule --add app='^System Information$' manage=off layer=above
        yabai -m rule --add app='JetBrains Toolbox' manage=off layer=above
        yabai -m rule --add app='Mullvad VPN' manage=off layer=above
        yabai -m rule --add app='Google Assistant' manage=off layer=above
        yabai -m rule --add app='Discord Canary' manage=off layer=above
        yabai -m rule --add app='Fig' border=off
      '';
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [inputs.fenix.overlays.default];
  };

  users.users.marshall = {
    name = "marshall";
    home = "/Users/marshall";
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
        orientation = "bottom";
        showhidden = true;
        tilesize = 48;
      };

      finder = {
        CreateDesktop = false;
      };
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};

    users.marshall = {pkgs, ...}: {
      imports = [./home.nix];
    };
  };
}
