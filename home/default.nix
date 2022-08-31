{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dotfiles.nix
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-doom-emacs.hmModule
  ];

  home.packages = with pkgs; [
    # NIX-ADD BEGIN
    acpi
    alejandra
    android-tools
    appflowy
    audacity
    authy
    bacon
    bandwhich
    binutils
    brightnessctl
    cachix
    cargo-edit
    cargo-udeps
    cht-sh
    cmake
    comma
    ddcutil
    dejsonlz4
    deno
    draconis
    eww
    file
    firefox-nightly-bin
    fzf
    gcc
    glib
    gnome.eog
    gnome.nautilus
    gnome.seahorse
    gnumake
    gotktrix
    gparted
    gpick
    grex
    grim
    gsettings-desktop-schemas
    headsetcontrol
    hyper
    inotifyTools
    jamesdsp
    jellyfin-ffmpeg
    jetbrains.idea-ultimate
    jq
    keybase
    keychain
    kotatogram-desktop
    libappindicator
    libffi
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lite-xl
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    mpvScripts.mpris
    mullvad-vpn
    nerdfonts
    ngrok
    nix-prefetch-scripts
    nodePackages.generator-code
    nodePackages.pnpm
    nodePackages.yo
    nodejs
    nospm
    notion-app-enhanced
    noto-fonts-cjk-sans
    obs-studio
    odin
    openal
    openjdk16-bootstrap
    p7zip
    pamixer
    papirus-icon-theme
    pavucontrol
    picom
    playerctl
    polymc
    pulseaudio
    python
    python310
    ranger
    rnix-lsp
    rofi
    rust-analyzer
    scons
    scrot
    slurp
    statix
    sumneko-lua-language-server
    swaybg
    swaynotificationcenter
    tealdeer
    unrar
    unzip
    usbimager
    waybar
    wf-recorder
    wineWowPackages.waylandFull
    wl-clipboard
    wl-color-picker
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdotool
    yarn
    zscroll
    # NIX-ADD END

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

    (inputs.replugged-overlay.lib.makeDiscordPlugged {
      inherit pkgs;

      discord = pkgs.discord-canary.override {withOpenASAR = true;};

      plugins = {
        inherit (inputs) theme-toggler tiktok-tts spotify-modal hastebin better-codeblocks pronoundb chat-components vpc-spotimbed simple-discord-crypt holy-notes;
      };

      themes = {
        inherit (inputs) catppuccin horizontal-server-list lavender context-icons fluent-icons;
      };
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

    go = {
      enable = true;
      package = pkgs.go_1_18;
    };

    mpv = {
      enable = true;

      scripts = with pkgs; [
        mpvScripts.mpris
      ];
    };

    mcfly = {
      enable = true;
      enableZshIntegration = true;
    };

    vscode = with pkgs; {
      enable = true;
      package = vscode-fhs;
    };

    git = {
      enable = true;
      userName = "marsupialgutz";
      userEmail = "mars@possums.xyz";
      delta.enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "DB41891AE0A1ED4D";
      };

      aliases = {
        "pushall" = "!git remote | xargs -L1 git push";
      };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    bat = {
      enable = true;
      config.theme = "catppuccin";

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
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      initExtraFirst = ''
        source ~/.cache/p10k-instant-prompt-marshall.zsh
        fpath+=~/.zfunc
      '';

      shellAliases = {
        se = "sudoedit";
        gc = "git commit";
        ga = "git add .";
        gcap = "ga; gc; git pushall";
        cat = "bat";
      };

      initExtra = ''
        my-backward-delete-word () {
            local WORDCHARS='~!#$%^&*(){}[]<>?+;'
            zle backward-delete-word
        }
        zle -N my-backward-delete-word

        bindkey -e
        bindkey "^[^?" my-backward-delete-word
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey '^[[1;5C' emacs-forward-word
        bindkey '^[[1;5D' emacs-backward-word
        bindkey '^[[A' up-line-or-search
        bindkey '^[[B' down-line-or-search

        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/home/marshall/.npm-packages/bin"
        export NODE_PATH="/home/marshall/.npm-packages/lib/node_modules"
        export EDITOR=nvim
        export VISUAL=nvim
        export NIXPKGS_ALLOW_UNFREE=1

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
        name = "Comic Code Ligatures";
        size = 12;
      };

      settings = {
        editor = "nvim";
        placement_strategy = "center";
        hide_window_decorations = "titlebar-only";
        background_opacity = "0.8";
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
        adjust_line_height = 3;
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

    doom-emacs = {
      enable = false;
      doomPrivateDir = ../dotfiles/doom.d;
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
        lualine.enable = true;
        telescope.enable = true;
        nvim-autopairs.enable = true;
        nvim-tree.enable = true;

        dashboard = {
          enable = true;

          header = [
            "                                         _.oo."
            "                 _.u[[/;:,.         .odMMMMMM´"
            "              .o888UU[[[/;:-.  .o@P^    MMM^  "
            "             oN88888UU[[[/;::-.        dP^    "
            "            dNMMNN888UU[[[/;:--.   .o@P^      "
            "           ,MMMMMMN888UU[[/;::-. o@^          "
            "           NNMMMNN888UU[[[/~.o@P^             "
            "           888888888UU[[[/o@^-..              "
            "          oI8888UU[[[/o@P^:--..               "
            "       .@^  YUU[[[/o@^;::---..                "
            "     oMP     ^/o@P^;:::---..                  "
            "  .dMMM    .o@^ ^;::---...                    "
            " dMMMMMMM@^`       `^^^^                      "
            "YMMMUP^                                       "
            " ^^                                           "
          ];

          footer = [
            "ooh, spacey"
          ];
        };

        treesitter = {
          enable = true;
          ensureInstalled = "all";
          nixGrammars = true;
        };

        comment-nvim.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        pkgs.myCopilotVim
        pkgs.myCokelinePlugin

        cmp_luasnip
        cmp-path
        cmp-buffer
        cmp-nvim-lsp
        catppuccin-nvim
        FTerm-nvim
        lightspeed-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        null-ls-nvim
        nvim-cmp
        nvim-lspconfig
        presence-nvim
        trouble-nvim
        which-key-nvim
        vim-cool
        vim-smoothie
      ];

      colorscheme = "catppuccin";

      extraConfigLua = ''
          vim.g.mapleader = ' '
          vim.g.astro_typescript = 'enable'
          vim.o.showmode = false
          vim.cmd('set mouse=a')
          vim.cmd('set guifont=Rec\\ Mono\\ Casual:h13')

          function map(mode, lhs, rhs, opts)
            local options = { noremap = true, silent = true }
            if opts then
              options = vim.tbl_extend("force", options, opts)
            end
            vim.api.nvim_set_keymap(mode, lhs, rhs, options)
          end

          local wk = require("which-key")

          wk.setup({
            window = {
              border = "single", -- none, single, double, shadow
              position = "bottom", -- bottom, top
              margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
              padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
              winblend = 0,
            },
            layout = {
              height = { min = 4, max = 25 }, -- min and max height of the columns
              width = { min = 20, max = 50 }, -- min and max width of the columns
              spacing = 3, -- spacing between columns
              align = "left", -- align columns left, center or right
            },
          })

          wk.register({
            c = {
              n = { "<cmd>DashboardNewFile<CR>", "New File" },
            },
            e = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
            f = {
              name = "Find",
              f = { "<cmd>DashboardFindFile<cr>", "Find File"},
              h = { "<cmd>DashboardFindHistory<cr>", "Find History"},
              a = { "<cmd>DashboardFindWord<cr>", "Find Word"},
            },
            b = {
              name = "Buffer",
              e = { "<Plug>(cokeline-pick-close)", "Close"},
              j = { "<Plug>(cokeline-pick-focus)", "Focus"},
            },
            l = {
              name = "LSP",
              a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"},
              k = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover"},
            },
          }, { prefix = "<Leader>" })

          wk.register({
            ["<c-t>"] = { "<cmd>lua require(\"FTerm\").toggle()<CR>", "Toggle Terminal" },
          }, { mode = "n" })

          wk.register({
            ["<c-t>"] = { "<C-\\><C-n><cmd>lua require(\"FTerm\").toggle()<CR>", "Toggle Terminal" },
          }, { mode = "t" })

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

          local get_hex = require('cokeline/utils').get_hex
          local is_picking_focus = require("cokeline/mappings").is_picking_focus
          local is_picking_close = require("cokeline/mappings").is_picking_close

          require('cokeline').setup({
            show_if_buffers_are_at_least = 2,
            default_hl = {
              fg = function(buffer)
                return
                  buffer.is_focused
                  and get_hex('Normal', 'fg')
                   or get_hex('Comment', 'fg')
              end,
              bg = get_hex('ColorColumn', 'bg'),
            },

            components = {
              {
                text = ' ',
                bg = get_hex('Normal', 'bg'),
              },
              {
                text = '',
                fg = get_hex('ColorColumn', 'bg'),
                bg = get_hex('Normal', 'bg'),
              },
              {
                  text = function(buffer)
                      if is_picking_focus() or is_picking_close() then
                          return buffer.pick_letter .. " "
        end
                      return buffer.devicon.icon
                  end,
                  fg = function(buffer)
                      if is_picking_focus() then
                          return yellow
        end
                      if is_picking_close() then
                          return red
                      end

                      if buffer.is_focused then
                          return dark
                      else
                          return light
                      end
                  end,
                  style = function(_)
                      return (is_picking_focus() or is_picking_close()) and "italic,bold" or nil
                  end
              },
              {
                text = ' ',
              },
              {
                text = function(buffer) return buffer.filename .. '  ' end,
                style = function(buffer)
                end,
              },
              {
                text = '',
                delete_buffer_on_left_click = true,
              },
              {
                text = '',
                fg = get_hex('ColorColumn', 'bg'),
                bg = get_hex('Normal', 'bg'),
              },
            },
          })

          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

          require'FTerm'.setup({
              border = 'double',
              dimensions  = {
                  height = 0.9,
                  width = 0.9,
              },
          })

          local cmp = require('cmp')
          local lspkind = require('lspkind')

          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
              end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'path' },
              { name = 'buffer' },
            }),
            formatting = {
              format = lspkind.cmp_format({
                mode = 'symbol',
                maxwidth = 50,
              })
            }
          })

          vim.opt.completeopt="menu,menuone,noselect"

          local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
          for _, server in ipairs({"rnix", "rust_analyzer", "astro"}) do
            require('lspconfig')[server].setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                      -- vim.lsp.buf.format({bufnr = bufnr})
                    end,
                  })
                end
              end,
            }
          end

          require("null-ls").setup({
            sources = {
              require("null-ls").builtins.formatting.alejandra,
            },
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
  };

  xdg.desktopEntries."idea-ultimate" = {
    name = "Intellij IDEA";
    exec = "steam-run idea-ultimate";
    icon = "idea-ultimate";
    settings.StartupWMClass = "jetbrains-idea";
  };

  wayland.windowManager.sway = {
    enable = false;
    extraOptions = ["--unsupported-gpu"];

    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
}
