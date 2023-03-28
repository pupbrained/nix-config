{
  inputs,
  pkgs,
  config,
  ...
}: let
  nodePackages_latest =
    pkgs.nodePackages_latest
    // {
      pnpm = pkgs.nodePackages_latest.pnpm.override {
        version = "8.0.0-rc.1";
        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/pnpm/-/pnpm-8.0.0-rc.1.tgz";
          sha512 = "sha512-hZpolpTa/pieTu+IPrrUjRuV1pJH21dTeenWGOKYMLK336PrKGfG5QtDsg8jBWEwgokAR7e3bBKDPii//htM6Q==";
        };
      };
    };
in
  with pkgs; {
    imports = with inputs; [
      pkgs/bat.nix
      pkgs/fish.nix
      pkgs/kitty.nix
      pkgs/nixvim.nix
      pkgs/vscode.nix
      nixvim.homeManagerModules.nixvim
    ];

    nixpkgs.overlays = [inputs.fenix.overlays.default];

    nix = {
      registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        max-jobs = "auto";
        flake-registry = "/etc/nix/registry.json";
        keep-derivations = true;
        keep-outputs = true;
        warn-dirty = false;

        trusted-users = ["marshall"];
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        extra-sandbox-paths = /nix/var/cache/ccache
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';
    };

    home = {
      packages =
        [
          # SNOW BEGIN
          alejandra
          apksigner
          bacon
          bitwarden-cli
          btop
          bun
          comma
          cachix
          cargo-edit
          cargo-udeps
          cmake
          comma
          deno
          duf
          erlang
          fd
          gcc
          gitoxide
          gleam
          grc
          huniq
          igrep
          iina
          jq
          jql
          keybase
          keychain
          lazygit
          macchina
          neovide
          nix-output-monitor
          nix-prefetch-scripts
          nodejs-19_x
          nurl
          pinentry_mac
          pkg-config
          python311
          python311Packages.pip
          riff
          ripgrep
          rm-improved
          rnix-lsp
          rnr
          statix
          tokei
          unrar
          unzip
          upx
          wget
          xcp
          xh
          yubikey-manager
          # SNOW END
        ]
        ++ (with nodePackages_latest; [
          eslint
          generator-code
          pnpm
          prettier
          typescript
          typescript-language-server
          yarn
        ]);

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      stateVersion = "23.05";
    };

    programs = {
      direnv.enable = true;
      exa.enable = true;
      gpg.enable = true;
      skim.enable = true;
      navi.enable = true;

      gh = {
        enable = true;
        extensions = with pkgs; [
          gh-eco
          gh-dash
          gh-markdown-preview
        ];
        settings.git_protocol = "ssh";
      };

      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "pupbrained";
        userEmail = "mars@pupbrained.xyz";

        signing = {
          signByDefault = true;
          key = "874E22DF2F9DFCB5";
        };

        aliases = {
          "pushall" = "!git remote | xargs -L1 git push";
        };

        extraConfig = {
          push.autoSetupRemote = true;
        };
      };

      go = {
        enable = true;
        package = pkgs.go_1_20;
        packages = {
          # bubbletea
          "github.com/charmbracelet/bubbletea" = builtins.fetchGit "https://github.com/charmbracelet/bubbletea";
        };
      };

      java = {
        enable = true;
        package = pkgs.jdk;
      };

      lazygit = {
        enable = true;

        settings = {
          gui.theme = {
            lightTheme = false;
            activeBorderColor = ["#a6e3a1" "bold"];
            inactiveBorderColor = ["#cdd6f4"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            selectedRangeBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#94e2d5"];
            cherryPickedCommitFgColor = ["#89b4fa"];
            unstagedChangesColor = ["red"];
          };
        };
      };

      starship = {
        enable = true;
        settings = {
          jobs.disabled = true;
          palette = "catppuccin_mocha";
          nix_shell.symbol = "❄️";

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
  }
