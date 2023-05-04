{
  inputs,
  pkgs,
  ...
}:
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
      trusted-users = ["marshall"];
      warn-dirty = false;
    };

    extraOptions = ''
      experimental-features = nix-command flakes
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
        cachix
        cargo-edit
        cargo-tauri
        cargo-udeps
        cmake
        comma
        deno
        duf
        erlang
        fd
        fend
        gcc
        gitoxide
        git-cliff
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
        rnr
        statix
        tokei
        typst
        typst-lsp
        unrar
        unzip
        upx
        wget
        xcp
        xh
        yubikey-manager
        # SNOW END
      ]
      ++ (with inputs; [
        caligula.packages.${pkgs.system}.default
        deadnix.packages.${pkgs.system}.default
      ])
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
    exa.enable = true;
    gpg.enable = true;
    java.enable = true;
    nix-index.enable = true;
    skim.enable = true;
    tealdeer.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

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
      aliases."pushall" = "!git remote | xargs -L1 git push";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      signing = {
        signByDefault = true;
        key = "874E22DF2F9DFCB5";
      };
    };

    go = {
      enable = true;
      package = pkgs.go_1_20;
      packages = {
        "github.com/charmbracelet/bubbletea" = builtins.fetchGit "https://github.com/charmbracelet/bubbletea";
      };
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
}
