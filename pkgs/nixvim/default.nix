{
  pkgs,
  config,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};

  mkVimPlugin = sources:
    pkgs.vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  codeium-vim = mkVimPlugin sources.codeium-vim;
  fidget-nvim = mkVimPlugin sources.fidget-nvim;
  illuminate-nvim = mkVimPlugin sources.illuminate-nvim;
  navbuddy-nvim = mkVimPlugin sources.navbuddy-nvim;
  overseer-nvim = mkVimPlugin sources.overseer-nvim;
in {
  programs.nixvim = {
    enable = true;
    extraConfigLua = builtins.readFile ./init.lua;
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      terminalColors = true;

      integrations = {
        barbar = true;
        fidget = true;
        gitsigns = true;
        illuminate = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        lsp_trouble = true;
        mini = true;
        native_lsp.enabled = true;
        navic.enabled = true;
        nvimtree = true;
        overseer = true;
        telescope = true;
        treesitter = true;
        treesitter_context = true;
        ts_rainbow2 = true;
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
      neovide_cursor_animation_length = 2.5e-2;
      neovide_cursor_vfx_mode = "railgun";
      neovide_background_color = "#1e1e2f";
      codeium_no_map_tab = 1;
      instant_username = "mars";
    };

    maps = config.nixvim.helpers.mkMaps {silent = true;} {
      normal = {
        "<C-t>".action = "<CMD>lua require('FTerm').toggle()<CR>";
        "<C-h>".action = "<CMD>BufferPrevious<CR>";
        "<C-l>".action = "<CMD>BufferNext<CR>";
        "<Leader>lg".action = "<CMD>LazyGit<CR>";
        "<Leader>la".action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
        "<Leader>lk".action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        "<Leader>be".action = "<CMD>BufferPickDelete<CR>";
        "<Leader>bf".action = "<CMD>BufferPick<CR>";
        "<Leader>e".action = "<CMD>NvimTreeToggle<CR>";
        "<Leader>a".action = "<CMD>lua require('alternate-toggler').toggleAlternate()<CR>";
        "<Leader>rn".action = "<CMD>lua require('renamer').rename()<CR>";
        "<Leader>p".action = "<CMD>!pst %<CR>";
      };

      terminal."<C-t>".action = "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>";

      visual."<Leader>rn".action = "<CMD>lua require('renamer').rename()<CR>";
    };

    plugins = {
      comment-nvim.enable = true;
      emmet.enable = true;
      nvim-autopairs.enable = true;
      nvim-lightbulb.enable = true;
      todo-comments.enable = true;

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
              end,
            })
          end
        '';

        servers = {
          eslint.enable = true;
          lua-ls.enable = true;
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
                group = "group";
              };
            };

            extraOptions.settings = {
              unstable_features = true;
              tab_spaces = 2;
              reorder_impl_items = true;
              indent_style = "Block";
              imports_layout = "HorizontalVertical";
              group_imports = "StdExternalCrate";
              normalize_comments = true;
              format_code_in_doc_comments = true;
            };
          };
        };
      };

      null-ls = {
        enable = true;
        sources.formatting = {
          alejandra.enable = true;
          nixfmt.enable = true;
          stylua.enable = true;
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

    extraPlugins = with pkgs.vimPlugins; [
      alternate-toggler-nvim
      barbecue-nvim
      codeium-vim
      diffview-nvim
      feline-nvim
      fidget-nvim
      FixCursorHold-nvim
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
      telescope-ui-select-nvim
      trouble-nvim
      vim-cool
      vim-smoothie
      vim-unimpaired
      vim-visual-multi
      virtual-types-nvim
      zen-mode-nvim
    ];
  };
}
