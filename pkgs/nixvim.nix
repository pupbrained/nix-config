{pkgs, ...}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};

  mkVimPlugin = sources:
    pkgs.vimUtils.buildVimPlugin {
      inherit (sources) src pname version;
    };

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  catppuccin-nvim = mkVimPlugin sources.catppuccin-nvim;
  codeium-vim = mkVimPlugin sources.codeium-vim;
  illuminate-nvim = mkVimPlugin sources.illuminate-nvim;
  navbuddy-nvim = mkVimPlugin sources.navbuddy-nvim;
  overseer-nvim = mkVimPlugin sources.overseer-nvim;

  emmet-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit (sources.emmet-vim) src pname version;
    buildInputs = [pkgs.zip];
  };
in {
  programs.nixvim = {
    enable = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 0;
      tabstop = 2;
      showtabline = 2;
      expandtab = true;
      smarttab = true;
      showmode = false;
      undofile = true;
      list = true;
      completeopt = "menuone,menuone,noselect";
    };

    globals = {
      mapleader = " ";
      rust_recommended_style = false;
      neovide_cursor_animation_length = 0.025;
      neovide_cursor_vfx_mode = "railgun";
      neovide_refresh_rate = 165;
      neovide_background_color = "#1e1e2f";
      codeium_no_map_tab = 1;
      instant_username = "mars";
      terminal_color_0 = "#45475a";
      terminal_color_1 = "#f38ba8";
      terminal_color_2 = "#a6e3a1";
      terminal_color_3 = "#f9e2af";
      terminal_color_4 = "#89b4fa";
      terminal_color_5 = "#f5c2e7";
      terminal_color_6 = "#94e2d5";
      terminal_color_7 = "#bac2de";
      terminal_color_8 = "#45475a";
      terminal_color_9 = "#f38ba8";
      terminal_color_10 = "#a6e3a1";
      terminal_color_11 = "#f9e2af";
      terminal_color_12 = "#89b4fa";
      terminal_color_13 = "#f5c2e7";
      terminal_color_14 = "#94e2d5";
      terminal_color_15 = "#bac2de";
    };

    maps = {
      normal = {
        "<C-t>" = {
          silent = true;
          action = "<CMD>lua require('FTerm').toggle()<CR>";
        };
        "<C-h>" = {
          silent = true;
          action = "<CMD>BufferPrevious<CR>";
        };
        "<C-l>" = {
          silent = true;
          action = "<CMD>BufferNext<CR>";
        };
        "<Leader>lg" = {
          silent = true;
          action = "<CMD>LazyGit<CR>";
        };
        "<Leader>la" = {
          silent = true;
          action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
        };
        "<Leader>lk" = {
          silent = true;
          action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        };
        "<Leader>be" = {
          silent = true;
          action = "<CMD>BufferPickDelete<CR>";
        };
        "<Leader>bf" = {
          silent = true;
          action = "<CMD>BufferPick<CR>";
        };
        "<Leader>e" = {
          silent = true;
          action = "<CMD>NvimTreeToggle<CR>";
        };
        "<Leader>a" = {
          silent = true;
          action = "<CMD>lua require('alternate-toggler').toggleAlternate()<CR>";
        };
        "<Leader>rn" = {
          silent = true;
          action = "<CMD>lua require('renamer').rename()<CR>";
        };
      };

      terminal."<C-t>" = {
        silent = true;
        action = "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>";
      };

      visual."<Leader>rn" = {
        silent = true;
        action = "<CMD>lua require('renamer').rename()<CR>";
      };
    };

    extraConfigLua = ''
      require('catppuccin').setup({
        flavour = 'mocha',
        color_overrides = {
          mocha = {
            base = '#1e1e2f'
          }
        },
        styles = {
          comments = { "italic" },
          properties = { "italic" },
          functions = { "bold" },
          keywords = { "italic" },
          operators = { "bold" },
          conditionals = { "bold" },
          loops = { "bold" },
          booleans = { "bold", "italic" }
        }
      })

      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
      vim.cmd('set mouse=a')
      vim.cmd('set guifont=IosevkaNerdFont\\ Nerd\\ Font:h18')
      vim.cmd.colorscheme('catppuccin')

      require('fidget').setup()
      require('gitsigns').setup()
      require('indent_blankline').setup()
      require('mini.starter').setup()
      require('mini.trailspace').setup()
      require('mini.comment').setup()
      require('mini.surround').setup()
      require('mini.move').setup()
      require('octo').setup()
      require('overseer').setup()
      require('renamer').setup()

      require('barbecue').setup({
        theme = 'catppuccin'
      })

      require('colorizer').setup({
        user_default_options = {
          names = false,
          mode = 'virtualtext'
        }
      })

      require("feline").setup({
        components = require('catppuccin.groups.integrations.feline').get()
      })

      require('FTerm').setup({
        border = 'rounded',
        dimensions = {
          height = 0.9,
          width = 0.9
        }
      })

      require('illuminate').configure({
        min_count_to_highlight = 2
      })

      require('mini.indentscope').setup({
        symbol = '│',
        draw = {
          delay = 50
        }
      })

      require('mini.jump2d').setup({
        mappings = {
          start_jumping = 's'
        }
      })

      require('nvim-treesitter.configs').setup({
        rainbow = {
          enable = true,
          query = 'rainbow-parens',
          strategy = require('ts-rainbow').strategy.global,
          disable = { 'tsx' }
        }
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(tbl)
          local set_offset = require('bufferline.api').set_offset

          local bufwinid
          local last_width
          local autocmd = vim.api.nvim_create_autocmd('WinScrolled', {
            callback = function()
              bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)

              local width = vim.api.nvim_win_get_width(bufwinid)
              if width ~= last_width then
                set_offset(width, 'FileTree')
                last_width = width
              end
            end,
          })

          vim.api.nvim_create_autocmd('BufWipeout', {
            buffer = tbl.buf,
            callback = function()
              vim.api.nvim_del_autocmd(autocmd)
              set_offset(0)
            end,
            once = true,
          })
        end,
        pattern = 'NvimTree', -- or any other filetree's `ft`
      })

      vim.keymap.set('i', '<C-j>', function () return vim.fn['codeium#Accept']() end, { expr = true })
    '';

    plugins = {
      # copilot.enable = true;
      nvim-autopairs.enable = true;

      barbar = {
        enable = true;
        autoHide = true;
        icons.diagnostics = {
          error.enable = true;
          hint.enable = true;
          info.enable = true;
          warn.enable = true;
        };
      };

      coq-nvim = {
        enable = true;
        autoStart = "shut-up";
        installArtifacts = true;
        recommendedKeymaps = true;
      };

      coq-thirdparty = {
        enable = true;
        # sources = [
        #   {
        #     accept_key = "<C-j>";
        #     short_name = "COP";
        #     src = "copilot";
        #   }
        # ];
      };

      lsp = {
        enable = true;

        onAttach = ''
          if client.server_capabilities.documentSymbolProvider then
              require('nvim-navic').attach(client, bufnr)
              require('nvim-navbuddy').attach(client, bufnr)
          end

          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if client.name == 'null-ls' then
                  local util = require 'vim.lsp.util'
                  local params = util.make_formatting_params({})
                  client.request('textDocument/formatting', params, nil, bufnr)
                end
                vim.lsp.buf.format({bufnr = bufnr})
                require('mini.trailspace').trim()
                require('mini.trailspace').trim_last_lines()
              end,
            })

            vim.api.nvim_create_autocmd('BufWritePre', {
              pattern = { '*.tsx', '*.jsx', '*.html' },
              group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
              callback = function()
                vim.cmd('silent!EslintFixAll')
                vim.fn.setline(1, vim.fn.systemlist("rustywind --stdin 2>/dev/null", vim.fn.getline(1, '$')))
              end,
            })
          end
        '';

        servers = {
          eslint.enable = true;
          nil_ls.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          gopls.enable = true;

          rust-analyzer = {
            enable = true;

            settings = {
              checkOnSave = true;
              check.command = "clippy";

              imports.granularity = {
                enforce = true;
                group = "item";
              };
            };

            extraOptions.settings = {
              unstable_features = true;
              tab_spaces = 2;
              reorder_impl_items = true;
              indent_style = "Block";
              normalize_comments = true;
              max_width = 100;
            };
          };
        };
      };

      null-ls = {
        enable = true;
        sources.formatting.alejandra.enable = true;
      };

      nvim-tree = {
        enable = true;
        git.enable = true;
        disableNetrw = true;

        diagnostics = {
          enable = true;
          icons = {
            hint = "";
            info = "";
            warning = "";
            error = "";
          };
        };
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      alternate-toggler-nvim
      barbecue-nvim
      catppuccin-nvim
      codeium-vim
      diffview-nvim
      emmet-vim
      feline-nvim
      fidget-nvim
      FTerm-nvim
      gitsigns-nvim
      illuminate-nvim
      indent-blankline-nvim
      instant-nvim
      lazygit-nvim
      lspkind-nvim
      luasnip
      markdown-preview-nvim
      mini-nvim
      mkdir-nvim
      navbuddy-nvim
      nui-nvim
      nvim-colorizer-lua
      nvim-lightbulb
      nvim-navic
      nvim-ts-rainbow2
      nvim-web-devicons
      octo-nvim
      overseer-nvim
      plenary-nvim
      presence-nvim
      renamer-nvim
      trouble-nvim
      vim-cool
      vim-smoothie
      vim-unimpaired
      vim-visual-multi
      zen-mode-nvim
    ];
  };
}
