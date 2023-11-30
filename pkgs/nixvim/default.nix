{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  sources = callPackage ../_sources/generated.nix {};

  mkVimPlugin = sources: vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  buffer-manager-nvim = mkVimPlugin sources.buffer-manager-nvim;
  buffertabs-nvim = mkVimPlugin sources.buffertabs-nvim;
  codeium-nvim = mkVimPlugin sources.codeium-nvim;
  lsp-lens-nvim = mkVimPlugin sources.lsp-lens-nvim;
in {
  programs.nixvim = {
    enable = true;
    enableMan = false;
    # package = inputs.neovim.packages.${system}.neovim;
    extraConfigLua = builtins.readFile ./init.lua;
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      terminalColors = true;

      integrations = {
        barbar = true;
        fidget = true;
        gitsigns = true;
        illuminate.enabled = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        leap = true;
        lsp_trouble = true;
        mini.enabled = true;
        native_lsp.enabled = true;
        navic.enabled = true;
        nvimtree = true;
        telescope.enabled = true;
        treesitter = true;
        treesitter_context = true;
      };

      styles = {
        booleans = ["bold" "italic"];
        conditionals = ["bold"];
        functions = ["bold"];
        keywords = ["italic"];
        loops = ["bold"];
        operators = ["bold"];
        properties = ["italic"];
      };
    };

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 0;
      tabstop = 2;
      expandtab = true;
      smarttab = true;
      showmode = false;
      undofile = true;
      list = true;
      completeopt = "menuone,menuone,noselect";
      laststatus = 3;
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    globals = {
      mapleader = " ";
      Lf_WindowPosition = "popup";
      rust_recommended_style = false;
      neovide_cursor_animation_length = 2.5e-2;
      neovide_cursor_vfx_mode = "railgun";
      neovide_transparency = 0.5;
      neovide_transparency_point = 0.8;
    };

    keymaps = [
      {
        key = "/";
        action = ":SearchBoxIncSearch<CR>";
        mode = "n";
      }
      {
        key = "<Leader>f";
        action = "<CMD>Telescope find_files<CR>";
        mode = "n";
      }
      {
        key = "<C-t>";
        action = "<CMD>Lspsaga term_toggle<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>bh";
        action = "<CMD>lua require('buffer_manager.ui').nav_prev()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>bl";
        action = "<CMD>lua require('buffer_manager.ui').nav_next()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>lg";
        action = "<CMD>LazyGit<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>la";
        action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>lk";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>bb";
        action = "<CMD>lua require('buffer_manager.ui').toggle_quick_menu()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>e";
        action = "<CMD>NvimTreeToggle<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>a";
        action = "<CMD>lua require('alternate-toggler').toggleAlternate()<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<Leader>rn";
        action = ":IncRename ";
        mode = ["n" "v"];
      }
      {
        key = "<Leader>p";
        action = "<CMD>!pst %<CR>";
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-t>";
        action = "<C-\\><C-n><CMD>Lspsaga term_toggle<CR>";
        mode = "t";
        options.silent = true;
      }
    ];

    plugins = {
      barbecue.enable = false;
      cmp-cmdline.enable = true;
      comment-nvim.enable = true;
      diffview.enable = true;
      emmet.enable = true;
      fidget.enable = true;
      hardtime.enable = true;
      indent-blankline.enable = true;
      leap.enable = true;
      leap.addDefaultMappings = true;
      lspkind.enable = true;
      luasnip.enable = true;
      markdown-preview.enable = true;
      navbuddy.enable = true;
      navic.enable = true;
      noice.enable = false;
      presence-nvim.enable = true;
      rainbow-delimiters.enable = true;
      rust-tools.enable = true;
      spider.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      typst-vim.enable = true;

      barbar = {
        enable = false;
        autoHide = true;
        icons.diagnostics = {
          error.enable = true;
          hint.enable = true;
          info.enable = true;
          warn.enable = true;
        };
      };

      conform-nvim = {
        enable = true;

        formatters = {
          rustfmt = {
            args = [
              "--config"
              "unstable_features=true,tab_spaces=2,reorder_impl_items=true,indent_style=Block,normalize_comments=true,imports_granularity=Crate,imports_layout=HorizontalVertical,group_imports=StdExternalCrate"
            ];
          };
        };

        formattersByFt = {
          lua = ["stylua"];
          nix = ["alejandra"];
          rust = ["rustfmt"];
          vue = ["eslint_d"];
          typescript = ["eslint_d"];
        };

        extraOptions = {
          format_on_save = {
            timeout_ms = 1000;
            lsp_fallback = true;
          };
        };
      };

      gitsigns = {
        enable = true;
        onAttach.function = ''
          function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, {expr=true})

            -- Actions
            map('n', '<leader>hs', gs.stage_hunk)
            map('n', '<leader>hr', gs.reset_hunk)
            map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end
        '';
      };

      illuminate = {
        enable = true;
        minCountToHighlight = 2;
      };

      inc-rename = {
        enable = true;
        inputBufferType = "dressing";
      };

      instant = {
        enable = true;
        username = "mars";
      };

      lsp = {
        enable = true;

        onAttach = ''
          if client.supports_method('textDocument/codeLens') then
            require('virtualtypes').attach(client, bufnr)
          end

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
                require('mini.trailspace').trim()
                require('mini.trailspace').trim_last_lines()
              end,
            })
          end
        '';

        servers = {
          eslint.enable = true;
          gopls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          typst-lsp.enable = true;
          vls.enable = true;
          volar.enable = true;

          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;

            settings = {
              checkOnSave = true;
              check.command = "clippy";
            };
          };
        };
      };

      lspsaga = {
        enable = true;
        lightbulb.sign = false;
      };

      mini = {
        enable = true;
        modules = {
          indentscope = {
            symbol = "│";
            draw = {delay = 50;};
          };
          move = {};
          starter = {};
          surround = {};
          trailspace = {};
        };
      };

      notify = {
        enable = true;
        fps = 60;
        topDown = false;
      };

      nvim-cmp = {
        enable = true;

        sources = [
          {name = "codeium";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
        ];

        window.completion.border = "rounded";

        mapping = {"<CR>" = "cmp.mapping.confirm()";};
        mappingPresets = ["insert"];

        formatting.format = lib.mkForce ''
          require('lspkind').cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = { Codeium = "", }
          })
        '';
      };

      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          names = false;
          mode = "virtualtext";
        };
      };

      nvim-jdtls = {
        enable = true;
        data = "/Users/marshall/.cache/jdt-language-server/workspace";
        configuration = "/Users/marshall/.cache/jdt-language-server/config";
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
        extraOptions.defaults.layout_config.vertical.height = 0.5;
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
      };
    };

    extraPlugins = with vimPlugins; [
      alternate-toggler-nvim # Toggle booleans
      buffer-manager-nvim
      buffertabs-nvim # Simple, fancy buffer tabs
      codeium-nvim # Codeium AI completion
      dressing-nvim # Fancier UI elements
      feline-nvim # Statusline
      FTerm-nvim # Floating terminal for neovim
      lazygit-nvim # Lazygit integration for neovim
      lsp-lens-nvim # JetBrains-style References and Definitions labels
      mkdir-nvim # Automatically create di
      neovim-fuzzy
      nui-nvim # UI components for neovim
      promise-async # Promises and async functions in lua
      renamer-nvim # Rename variables easily
      #satellite-nvim
      searchbox-nvim
      telescope-ui-select-nvim # Sets ui-select to use telescope
      vim-cool # Automatically remove highlights after search
      vim-smoothie # Smooth scrolling
      vim-unimpaired # Handy bracket mappings
      vim-visual-multi # Multiple cursors for neovim
      virtual-types-nvim # Shows types of variables next to them
    ];
  };
}
