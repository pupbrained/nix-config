{
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  imports = with inputs; [
    pkgs/kitty.nix
    pkgs/fish.nix
    pkgs/nixvim

    nix-index-database.hmModules.nix-index
    nixvim.homeManagerModules.nixvim
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    overlays = [
      (final: _prev: {
        catppuccin-folders =
          final.callPackage ./pkgs/catppuccin-folders.nix {};

        codeium-ls = final.callPackage ./pkgs/codeium.nix {};
      })
    ];
  };

  home = {
    username = "marshall";
    homeDirectory = "/home/marshall";

    file.codeium_ls = {
      target = ".codeium/bin/e829be46431d9d5c061068a9b704357be77f6617/language_server_linux_arm";
      source = "${codeium-ls}/bin/language_server_linux_arm";
    };

    packages =
      [
        adw-gtk3
        armcord
        box64
        distrobox
        edk2
        firefox
        gradience
        grc
        gtkcord4
        jdk8
        kitty
        macchina
        prismlauncher
        wl-clipboard
      ]
      ++ (with gnomeExtensions; [
        blur-my-shell
        just-perfection
        pop-shell
        rounded-window-corners
        user-themes-x
      ]);
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adw-gtk3-dark";
      package = adw-gtk3;
    };

    cursorTheme = {
      name = "Catppuccin-Mocha-Green-Cursors";
      package = pkgs.catppuccin-cursors.mochaGreen;
    };

    iconTheme = {
      package = pkgs.catppuccin-folders;
      name = "Papirus";
    };
  };

  programs = {
    exa.enable = true;
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;

    bat = {
      enable = true;
      config.theme = "catppuccin";

      themes = {
        catppuccin = builtins.readFile (fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
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

      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        push.autoSetupRemote = true;
      };

      #   signing = {
      #     signByDefault = true;
      #     key = "874E22DF2F9DFCB5";
      #   };
    };

    starship = {
      enable = true;
      settings = {
        jobs.disabled = true;
        palette = "catppuccin_mocha";
        nix_shell.symbol = "❄️  ";

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };

    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
