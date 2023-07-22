{
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  imports = with inputs; [
    pkgs/nixvim
    pkgs/vscode
    pkgs/bat.nix
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
        # SNOW BEGIN
        alejandra
        apksigner
        bacon
        bitwarden-cli
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
        gcc
        gitoxide
        git-cliff
        gleam
        grc
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
        nodejs_20
        nurl
        opam
        pinentry_mac
        pkg-config
        repgrep
        riff
        ripgrep
        ripgrep-all
        rm-improved
        rnr
        statix
        stylua
        tokei
        typst
        typst-lsp
        unrar
        unzip
        upx
        vgrep
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
    exa.enable = true;
    gpg.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    skim.enable = true;
    tealdeer.enable = true;

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

      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        push.autoSetupRemote = true;
      };

      signing = {
        signByDefault = true;
        key = "874E22DF2F9DFCB5";
      };
    };

    gitui = {
      enable = true;

      package = let
        sources = pkgs.callPackage ./pkgs/_sources/generated.nix {};
      in
        pkgs.rustPlatform.buildRustPackage rec {
          inherit (sources.gitui) src pname version;

          cargoLock = sources.gitui.cargoLock."Cargo.lock";

          nativeBuildInputs = [pkg-config];

          buildInputs = with pkgs;
            [openssl]
            ++ lib.optional stdenv.isLinux xclip
            ++ lib.optionals stdenv.isDarwin [
              libiconv
              pkgs.darwin.apple_sdk.frameworks.Security
              pkgs.darwin.apple_sdk.frameworks.AppKit
            ];

          OPENSSL_NO_VENDOR = 1;

          postPatch = "rm .cargo/config";

          meta = with lib; {
            description = "Blazing fast terminal-ui for Git written in Rust";
            homepage = "https://github.com/extrawurst/gitui";
            changelog = "https://github.com/extrawurst/gitui/blob/${version}/CHANGELOG.md";
            license = licenses.mit;
            maintainers = with maintainers; [Br1ght0ne yanganto];
          };
        };

      keyConfig = ''
        (
          move_left:  Some((code: Char('h'); modifiers: (bits: 0;),)),
          move_right: Some((code: Char('l'); modifiers: (bits: 0;),)),
          move_up:    Some((code: Char('k'); modifiers: (bits: 0;),)),
          move_down:  Some((code: Char('j'); modifiers: (bits: 0;),)),
          stash_open: Some((code: Char('l'); modifiers: (bits: 0;),)),
          open_help:  Some((code:      F(1); modifiers: (bits: 0;),))
        )
      '';

      theme = ''
        (
          selected_tab: Reset,
          command_fg: Rgb(205, 214, 244),
          selection_bg: Rgb(88, 91, 112),
          selection_fg: Rgb(205, 214, 244),
          cmdbar_bg: Rgb(24, 24, 37),
          cmdbar_extra_lines_bg: Rgb(24, 24, 37),
          disabled_fg: Rgb(127, 132, 156),
          diff_line_add: Rgb(166, 227, 161),
          diff_line_delete: Rgb(243, 139, 168),
          diff_file_added: Rgb(249, 226, 175),
          diff_file_removed: Rgb(235, 160, 172),
          diff_file_moved: Rgb(203, 166, 247),
          diff_file_modified: Rgb(250, 179, 135),
          commit_hash: Rgb(180, 190, 254),
          commit_time: Rgb(186, 194, 222),
          commit_author: Rgb(116, 199, 236),
          danger_fg: Rgb(243, 139, 168),
          push_gauge_bg: Rgb(137, 180, 250),
          push_gauge_fg: Rgb(30, 30, 46),
          tag_fg: Rgb(245, 224, 220),
          branch_fg: Rgb(148, 226, 213)
        )
      '';
    };

    go = {
      enable = true;
      package = pkgs.go_1_20;

      packages = {
        "github.com/charmbracelet/bubbletea" =
          builtins.fetchGit "https://github.com/charmbracelet/bubbletea";
      };
    };

    # helix = {
    #   enable = true;
    #
    #   languages = [
    #     {
    #       name = "nix";
    #       auto-format = true;
    #       language-server.command = "${inputs.nil.packages.${pkgs.system}.default}/bin/nil";
    #       formatter = {
    #         command = "alejandra";
    #         args = ["-"];
    #       };
    #     }
    #   ];
    #
    #   settings = {
    #     theme = "catppuccin";
    #     editor = {
    #       line-number = "relative";
    #       lsp.display-messages = true;
    #       cursor-shape = {
    #         insert = "bar";
    #         normal = "block";
    #         select = "underline";
    #       };
    #     };
    #   };
    #
    #   themes = {
    #     catppuccin = let
    #       rosewater = "#f5e0dc";
    #       flamingo = "#f2cdcd";
    #       pink = "#f5c2e7";
    #       mauve = "#cba6f7";
    #       red = "#f38ba8";
    #       maroon = "#eba0ac";
    #       peach = "#fab387";
    #       yellow = "#f9e2af";
    #       green = "#a6e3a1";
    #       teal = "#94e2d5";
    #       sky = "#89dceb";
    #       sapphire = "#74c7ec";
    #       blue = "#89b4fa";
    #       lavender = "#b4befe";
    #       text = "#cdd6f4";
    #       subtext1 = "#bac2de";
    #       subtext0 = "#a6adc8";
    #       overlay2 = "#9399b2";
    #       overlay1 = "#7f849c";
    #       overlay0 = "#6c7086";
    #       surface2 = "#585b70";
    #       surface1 = "#45475a";
    #       surface0 = "#313244";
    #       base = "#1e1e2e";
    #       mantle = "#181825";
    #       crust = "#11111b";
    #       cursorline = "#2a2b3c";
    #       secondary_cursor = "#b5a6a8";
    #     in {
    #       type = yellow;
    #       constructor = sapphire;
    #       "constant" = peach;
    #       "constant.builtin" = peach;
    #       "constant.character" = teal;
    #       "constant.character.escape" = pink;
    #       "string" = green;
    #       "string.regexp" = peach;
    #       "string.special" = blue;
    #       comment = {
    #         fg = overlay1;
    #         modifiers = ["italic"];
    #       };
    #       "variable" = "text";
    #       "variable.parameter" = {
    #         fg = maroon;
    #         modifiers = ["italic"];
    #       };
    #       "variable.builtin" = red;
    #       "variable.other.member" = teal;
    #       label = sapphire;
    #       "punctuation" = overlay2;
    #       "punctuation.special" = sky;
    #       "keyword" = mauve;
    #       "keyword.control.conditional" = {
    #         fg = mauve;
    #         modifiers = ["italic"];
    #       };
    #       operator = sky;
    #       "function" = blue;
    #       "function.macro" = mauve;
    #       tag = mauve;
    #       attribute = blue;
    #       namespace = {
    #         fg = blue;
    #         modifiers = ["italic"];
    #       };
    #       special = blue;
    #       markup.heading.marker = {
    #         fg = peach;
    #         modifiers = ["bold"];
    #       };
    #       markup.heading."1" = lavender;
    #       markup.heading."2" = mauve;
    #       markup.heading."3" = green;
    #       markup.heading."4" = yellow;
    #       markup.heading."5" = pink;
    #       markup.heading."6" = teal;
    #       markup.list = mauve;
    #       markup.bold = {modifiers = ["bold"];};
    #       markup.italic = {modifiers = ["italic"];};
    #       markup.link.url = {
    #         fg = rosewater;
    #         modifiers = ["italic" "underlined"];
    #       };
    #       markup.link.text = blue;
    #       markup.raw = flamingo;
    #       diff.plus = green;
    #       diff.minus = red;
    #       diff.delta = blue;
    #       ui.background = {
    #         fg = text;
    #         bg = base;
    #       };
    #       ui.linenr = {fg = surface1;};
    #       ui.linenr.selected = {fg = lavender;};
    #       ui.statusline = {
    #         fg = subtext1;
    #         bg = mantle;
    #       };
    #       ui.statusline.inactive = {
    #         fg = surface2;
    #         bg = mantle;
    #       };
    #       ui.statusline.normal = {
    #         fg = base;
    #         bg = lavender;
    #         modifiers = ["bold"];
    #       };
    #       ui.statusline.insert = {
    #         fg = base;
    #         bg = green;
    #         modifiers = ["bold"];
    #       };
    #       ui.statusline.select = {
    #         fg = base;
    #         bg = flamingo;
    #         modifiers = ["bold"];
    #       };
    #       ui.popup = {
    #         fg = text;
    #         bg = surface0;
    #       };
    #       ui.window = {fg = "crust";};
    #       ui.help = {
    #         fg = overlay2;
    #         bg = surface0;
    #       };
    #       ui.bufferline = {
    #         fg = subtext0;
    #         bg = mantle;
    #       };
    #       ui.bufferline.active = {
    #         fg = mauve;
    #         bg = base;
    #         underline = {
    #           color = mauve;
    #           style = "line";
    #         };
    #       };
    #       "ui.bufferline.background" = {bg = crust;};
    #       "ui.text" = text;
    #       "ui.text.focus" = {
    #         fg = text;
    #         bg = surface0;
    #         modifiers = ["bold"];
    #       };
    #       "ui.text.inactive" = {fg = overlay1;};
    #       "ui.virtual" = overlay0;
    #       "ui.virtual.ruler" = {bg = surface0;};
    #       "ui.virtual.indent-guide" = surface0;
    #       "ui.virtual.inlay-hint" = {
    #         fg = surface1;
    #         bg = mantle;
    #       };
    #       "ui.selection" = {bg = surface1;};
    #       "ui.cursor" = {
    #         fg = base;
    #         bg = secondary_cursor;
    #       };
    #       ui.cursor.primary = {
    #         fg = base;
    #         bg = rosewater;
    #       };
    #       ui.cursor.match = {
    #         fg = peach;
    #         modifiers = ["bold"];
    #       };
    #       ui.cursorline.primary = {bg = cursorline;};
    #       ui.highlight = {
    #         bg = surface1;
    #         modifiers = ["bold"];
    #       };
    #       ui.menu = {
    #         fg = overlay2;
    #         bg = surface0;
    #       };
    #       ui.menu.selected = {
    #         fg = text;
    #         bg = surface1;
    #         modifiers = ["bold"];
    #       };
    #       diagnostic.error = {
    #         underline = {
    #           color = red;
    #           style = curl;
    #         };
    #       };
    #       diagnostic.warning = {
    #         underline = {
    #           color = yellow;
    #           style = curl;
    #         };
    #       };
    #       diagnostic.info = {
    #         underline = {
    #           color = sky;
    #           style = curl;
    #         };
    #       };
    #       diagnostic.hint = {
    #         underline = {
    #           color = teal;
    #           style = curl;
    #         };
    #       };
    #       error = red;
    #       warning = yellow;
    #       info = sky;
    #       hint = teal;
    #     };
    #   };
    # };

    java = {
      enable = true;
      package = pkgs.jdk17;
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
