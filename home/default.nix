{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dotfiles.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.packages = with pkgs; [
    acpi
    alejandra
    amp
    android-tools
    audacity
    binutils
    brightnessctl
    busybox
    cachix
    cargo-binutils
    cinnamon.nemo
    cmake
    comma
    draconis
    ffmpeg
    file
    firefox-nightly-bin
    fluffychat
    gcc
    gh
    github-desktop
    gnome.eog
    gnome.seahorse
    gnumake
    gpick
    headsetcontrol
    herbe
    inotifyTools
    jamesdsp
    jetbrains.idea-ultimate
    jq
    keychain
    kotatogram-desktop
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    most
    mpv
    neovide
    neovim-nightly
    nerdfonts
    nix-prefetch-scripts
    nodejs
    notion-app-enhanced
    noto-fonts-cjk-sans
    openjdk16-bootstrap
    p7zip
    pamixer
    papirus-icon-theme
    pavucontrol
    playerctl
    polymc
    python
    python310
    redshift
    rofi
    rust-analyzer
    scrot
    statix
    sumneko-lua-language-server
    tldr
    unrar
    unzip
    upower
    wineWowPackages.full
    xclip
    xdotool
    yarn
    (spotify-spicetified.override {
      theme = "catppuccin";
      colorScheme = "mauve";
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      customExtensions = {
        "catppuccin.js" = "${catppuccin-spicetify}/catppuccin.js";
      };
      enabledExtensions = [
        "catppuccin.js"
      ];
    })
    (pkgs.discord-plugged.override {
      plugins = with inputs; [theme-toggler powercord-tiktok-tts];
      themes = with inputs; [lavender-discord catppuccin horizontal-server-list sur-cord];
    })
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
  ];

  programs = {
    direnv.enable = true;
    gpg.enable = true;
    nix-index.enable = true;

    vscode = with pkgs; {
      enable = true;
      package = vscodeInsiders;
    };

    git = {
      enable = true;
      userName = "marsupialgutz";
      userEmail = "mars@possums.xyz";
      signing = {
        signByDefault = true;
        key = "DB41891AE0A1ED4D";
      };
      diff-so-fancy.enable = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    bat = {
      enable = true;
      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "sublime-text";
            rev = "0b7ac201ce4ec7bac5e0063b9a7483ca99907bbf";
            sha256 = "1kn5v8g87r6pjzzij9p8j7z9afc6fj0n8drd24qyin8p1nrlifi1";
          }
          + "/Catppuccin.tmTheme");
      };
      config.theme = "catppuccin";
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtraFirst = ''
        source ~/.cache/p10k-instant-prompt-marshall.zsh
      '';
      shellAliases = {
        se = "sudoedit";
        gc = "git commit";
        ga = "git add .";
        gcap = "ga; gc; gp";
        cat = "bat";
      };
      initExtra = ''
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey '^[[1;5C' emacs-forward-word
        bindkey '^[[1;5D' emacs-backward-word
        bindkey '^[[A' up-line-or-search
        bindkey '^[[B' down-line-or-search

        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin"
        export EDITOR=lvim
        export VISUAL=lvim
        export NIXPKGS_ALLOW_UNFREE=1
        export PAGER=most

        draconis
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      zplug = {
        enable = true;
        plugins = [
          {name = "zsh-users/zsh-autosuggestions";}
          {name = "zsh-users/zsh-syntax-highlighting";}
          {name = "zsh-users/zsh-history-substring-search";}
          {name = "chisui/zsh-nix-shell";}
          {
            name = "romkatv/powerlevel10k";
            tags = ["as:theme" "depth:1"];
          }
          {
            name = "plugins/git";
            tags = ["from:oh-my-zsh"];
          }
        ];
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd" "cd"];
    };

    kitty = {
      enable = true;
      font = {
        name = "Rec Mono Casual";
        size = 12;
      };
      settings = {
        editor = "nvim";
        placement_strategy = "center";
        hide_window_decorations = "titlebar-only";
        background_opacity = "0.95";
        inactive_text_alpha = 1;
        scrollback_lines = 5000;
        wheel_scroll_multiplier = 5;
        touch_scroll_multiplier = 1;
        tab_bar_min_tabs = 1;
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index} - {title}";
        cursor_shape = "beam";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
        adjust_line_height = 5;
        adjust_column_width = 0;
        foreground = "#CDD6F4";
        background = "#1E1E2E";
        selection_foreground = "#1E1E2E";
        selection_background = "#F5E0DC";
        cursor = "#F5E0DC";
        cursor_text_color = "#1E1E2E";
        url_color = "#B4BEFE";
        active_border_color = "#CBA6F7";
        inactive_border_color = "#8E95B3";
        bell_border_color = "#EBA0AC";
        active_tab_foreground = "#11111B";
        active_tab_background = "#CBA6F7";
        inactive_tab_foreground = "#CDD6F4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111B";
        mark1_foreground = "#1E1E2E";
        mark1_background = "#87B0F9";
        mark2_foreground = "#1E1E2E";
        mark2_background = "#CBA6F7";
        mark3_foreground = "#1E1E2E";
        mark3_background = "#74C7EC";
        color0 = "#45475A";
        color8 = "#45475A";
        color1 = "#F38BA8";
        color9 = "#F38BA8";
        color2 = "#A6E3A1";
        color10 = "#A6E3A1";
        color3 = "#F9E2AF";
        color11 = "#F9E2AF";
        color4 = "#89B4FA";
        color12 = "#89B4FA";
        color5 = "#F5C2E7";
        color13 = "#F5C2E7";
        color6 = "#94E2D5";
        color14 = "#94E2D5";
        color7 = "#BAC2DE";
        color15 = "#BAC2DE";
      };
    };

    nixvim = {
      enable = true;
      options = {
        number = true;
        relativenumber = true;
        shiftwidth = 0;
        tabstop = 2;
        smarttab = true;
        expandtab = true;
      };
      plugins = {
        lsp = {
          enable = true;
          servers = {
            rnix-lsp.enable = true;
          };
        };
        lualine.enable = true;
        telescope.enable = true;
        nvim-tree.enable = true;

        dashboard = {
          enable = true;
          executive = "telescope";
          header = [
            "          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄         "
            "        ▄▀░░░░░░░░░░░░▄░░░░░░░▀▄       "
            "        █░░▄░░░░▄░░░░░░░░░░░░░░█       "
            "        █░░░░░░░░░░░░▄█▄▄░░▄░░░█ ▄▄▄   "
            " ▄▄▄▄▄  █░░░░░░▀░░░░▀█░░▀▄░░░░░█▀▀░██  "
            " ██▄▀██▄█░░░▄░░░░░░░██░░░░▀▀▀▀▀░░░░██  "
            "  ▀██▄▀██░░░░░░░░▀░██▀░░░░░░░░░░░░░▀██ "
            "    ▀████░▀░░░░▄░░░██░░░▄█░░░░▄░▄█░░██ "
            "       ▀█░░░░▄░░░░░██░░░░▄░░░▄░░▄░░░██ "
            "       ▄█▄░░░░░░░░░░░▀▄░░▀▀▀▀▀▀▀▀░░▄▀  "
            "      █▀▀█████████▀▀▀▀████████████▀    "
            "      ████▀  ███▀      ▀███  ▀██▀      "
            "                                       "
            "              N Y A V I M              "
          ];
          footer = [
            "nyaa :3c meow x3 meow mrowww nyaaaa :333"
          ];
        };
        treesitter = {
          enable = true;
          ensureInstalled = "all";
          nixGrammars = true;
        };
        barbar = {
          enable = true;
          animations = true;
          autoHide = true;
          closeable = true;
          icons = true;
        };
      };
      extraPlugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        lualine-nvim
        neogit
        null-ls-nvim
        presence-nvim
        toggleterm-nvim
        trouble-nvim
        which-key-nvim
        vim-cool
        vim-smoothie
      ];
      colorscheme = "catppuccin";
      extraConfigLua = ''
        vim.g.mapleader = ' '
        vim.o.showmode = false
        vim.cmd('set mouse=a')
        vim.cmd('set guifont=Rec\\ Mono\\ Casual:h13')

        function map(mode, lhs, rhs, opts)
          local options = { noremap = true }
          if opts then
            options = vim.tbl_extend("force", options, opts)
          end
          vim.api.nvim_set_keymap(mode, lhs, rhs, options)
        end

        map("n", "<Leader>fb", ":DashboardJumpMarks<CR>")
        map("n", "<Leader>tc", ":DashboardChangeColorscheme<CR>")
        map("n", "<Leader>ff", ":DashboardFindFile<CR>")
        map("n", "<Leader>fh", ":DashboardFindHistory<CR>")
        map("n", "<Leader>fa", ":DashboardFindWord<CR>")
        map("n", "<Leader>cn", ":DashboardNewFile<CR>")
        map("n", "<Leader>e", ":NvimTreeToggle<CR>")

        local colors = {
          blue   = '#89b4fa',
          cyan   = '#89dceb',
          black  = '#1e1e2e',
          white  = '#cdd6f4',
          red    = '#f38ba8',
          violet = '#CBA6F7',
          grey   = '#12131F',
        }

        local bubbles_theme = {
          normal = {
            a = { fg = colors.black, bg = colors.violet },
            b = { fg = colors.white, bg = colors.grey },
            c = { fg = colors.black, bg = colors.black },
          },

          insert = { a = { fg = colors.black, bg = colors.blue } },
          visual = { a = { fg = colors.black, bg = colors.cyan } },
          replace = { a = { fg = colors.black, bg = colors.red } },

          inactive = {
            a = { fg = colors.white, bg = colors.black },
            b = { fg = colors.white, bg = colors.black },
            c = { fg = colors.black, bg = colors.black },
          },
        }

        require('lualine').setup {
          options = {
            theme = bubbles_theme,
            component_separators = '|',
            section_separators = { left = '', right = '' },
          },
          sections = {
            lualine_a = {
              { 'mode', separator = { left = '' }, right_padding = 2 },
            },
            lualine_b = { 'filename', 'branch' },
            lualine_c = { 'fileformat' },
            lualine_x = {},
            lualine_y = { 'filetype', 'progress' },
            lualine_z = {
              { 'location', separator = { right = '' }, left_padding = 2 },
            },
          },
          inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'location' },
          },
          tabline = {},
          extensions = {},
        }

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        require("which-key").setup()
        require("toggleterm").setup()

        require("null-ls").setup({
          sources = {
            require("null-ls").builtins.formatting.alejandra,
          },
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({bufnr = bufnr})
                end,
              })
            end
          end,
        })
      '';
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "gnome3";
    };
    picom = {
      enable = true;
      blur = true;
      extraOptions = ''
        blur-method = "dual_kawase";
        strength = 15;
      '';
      experimentalBackends = true;

      shadowExclude = ["bounding_shaped && !rounded_corners"];

      fade = true;
      fadeDelta = 7;
      fadeExclude = [
        "class_g = 'Rofi'"
      ];

      vSync = true;
      opacityRule = [
        "100:class_g   *?= 'Chromium-browser'"
        "100:class_g   *?= 'Firefox'"
        "100:class_g   *?= 'gitkraken'"
        "100:class_g   *?= 'emacs'"
        "100:class_g   ~=  'jetbrains'"
        "100:class_g   *?= 'slack'"
      ];
    };
  };

  xdg.desktopEntries."idea-ultimate" = {
    name = "Intellij IDEA";
    exec = "steam-run idea-ultimate";
    icon = "idea-ultimate";
    settings.StartupWMClass = "jetbrains-idea";
  };

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
    extraSessionCommands = ''
      export WLR_DRM_DEVICES = /dev/dri/card1:/dev/dri/card0
      export CLUTTER_BACKEND=wayland
      export SDL_VIDEODRIVER=wayland
      export XDG_SESSION_TYPE=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export MOZ_ENABLE_WAYLAND=1
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
    '';
  };
}
