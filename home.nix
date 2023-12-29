{
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  imports = with inputs; [
    pkgs/fish.nix
    pkgs/kitty.nix

    nixvim.homeManagerModules.nixvim
    nix-index-database.hmModules.nix-index
  ];

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  nix.registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

  home = {
    packages =
      [
        alejandra
        apksigner
        bacon
        btop
        bun
        cachix
        cargo-edit
        cargo-udeps
        cmake
        deno
        duf
        edgedb
        emacs29
        erlang
        eternal-terminal
        fd
        fend
        fzy
        gcc
        git-cliff
        gleam
        grc
        helix
        huniq
        hurl
        igrep
        jq
        jql
        keybase
        keychain
        macchina
        monolith
        nix-output-monitor
        nix-prefetch-scripts
        nixd
        nodejs_21
        nurl
        pinentry_mac
        pkg-config
        repgrep
        riff
        ripgrep
        rm-improved
        rnr
        statix
        stylua
        tailspin
        tokei
        typst
        typst-live
        typstfmt
        unrar
        unzip
        upx
        vgrep
        wget
        xcp
        xh
        yubikey-manager
      ]
      ++ (with inputs; [
        caligula.packages.${pkgs.system}.default
        deadnix.packages.${pkgs.system}.default
        nixvim-config.packages.${pkgs.system}.default
      ])
      ++ (with nodePackages_latest; [
        eslint
        pnpm
        prettier
        typescript
        typescript-language-server
        yarn
      ])
      ++ (with darwin.apple_sdk.frameworks; [
        AppKit
        Carbon
        Cocoa
        CoreFoundation
        DisplayServices
        IOKit
        Security
        WebKit
      ]);

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    stateVersion = "23.05";
  };

  programs = {
    eza.enable = true;
    gpg.enable = true;
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
    skim.enable = true;
    tealdeer.enable = true;

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

    gh = {
      enable = true;
      settings.git_protocol = "ssh";

      extensions = with pkgs; [gh-eco gh-dash gh-markdown-preview];
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
        key = "874E22DF2F9DFCB5";
      };
    };

    go = {
      enable = true;

      packages = {
        "github.com/charmbracelet/bubbletea" =
          builtins.fetchGit "https://github.com/charmbracelet/bubbletea";
      };
    };

    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    lazygit = {
      enable = true;

      settings.gui.theme = {
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

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        local c = wezterm.config_builder()

        c.color_scheme = 'Catppuccin Mocha'
        c.default_cursor_style = 'BlinkingBar'
        c.font = wezterm.font_with_fallback({ 'Maple Mono SC NF', 'Maple Mono NF' })
        c.font_size = 15.0
        c.hide_tab_bar_if_only_one_tab = true
        c.macos_window_background_blur = 20
        c.use_fancy_tab_bar = false
        c.window_decorations = 'RESIZE'
        c.window_background_opacity = 0.85
        c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

        wezterm.plugin
          .require("https://github.com/nekowinston/wezterm-bar")
          .apply_to_config(c)

        return c
      '';
    };

    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };
}
