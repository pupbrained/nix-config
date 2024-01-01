{
  inputs,
  config,
  pkgs,
  ...
}:
with pkgs; {
  imports = with inputs; [
    ./pkgs/fish.nix
    ./pkgs/hyprland.nix
    ./pkgs/kitty.nix

    hyprland.homeManagerModules.default
    nix-index-database.hmModules.nix-index
    nixvim.homeManagerModules.nixvim
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = with pkgs; [
        "electron-25.9.0"
      ];
    };

    overlays = with inputs; [
      neovim-nightly-overlay.overlay
      rust-overlay.overlays.default
      (final: _: {
        catppuccin-folders = final.callPackage ./pkgs/catppuccin-folders.nix {};
      })
    ];
  };

  home = {
    homeDirectory = "/home/marshall";
    username = "marshall";

    packages =
      [
        alejandra
        betterbird
        blueberry
        bluez
        bun
        clang
        distrobox
        flite
        grc
        jamesdsp
        jdk17
        kate
        ksshaskpass
        libsForQt5.bismuth
        lightly-boehs
        lld
        macchina
        neovide
        obsidian
        plasma-browser-integration
        playerctl
        prismlauncher
        protobuf
        pw-volume
        swaynotificationcenter
        vesktop
        waybar
        winetricks
        wineWowPackages.staging
        wl-clipboard
        woeusb-ng
        wofi
        xclip

        (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      ]
      ++ (with gnome; [
        file-roller
        nautilus
      ])
      ++ (with inputs; [
        thorium.packages.${pkgs.system}.default
        nh.packages.${pkgs.system}.default
        nixvim-config.packages.${pkgs.system}.default
      ])
      ++ (with jetbrains; [
        (plugins.addPlugins idea-ultimate ["github-copilot"])
      ]);
  };

  programs = {
    carapace.enable = true;
    eza.enable = true;
    gpg.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;
    skim.enable = true;
    tealdeer.enable = true;

    atuin = {
      enable = true;
      settings = {
        inline_height = 20;
        show_preview = true;
        style = "compact";
      };
    };

    bat = {
      enable = true;
      config.theme = "catppuccin";

      themes.catppuccin = {
        src = fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };

        file = "/Catppuccin-mocha.tmTheme";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "pupbrained";
      userEmail = "mars@pupbrained.xyz";
      aliases."pushall" = "!git remote | xargs -L1 git push";
      difftastic.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      signing = {
        signByDefault = true;
        key = "1AC6742D7B475F34";
      };
    };
  };

  services = {
    cliphist.enable = true;
    espanso.enable = true;

    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
