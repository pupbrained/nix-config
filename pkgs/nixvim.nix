{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  programs.nixvim = {
    enable = true;
    package = inputs.neovim.packages.${pkgs.system}.default;
    colorscheme = "catppuccin";

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
      neovide_refresh_rate = 144;
      terminal_color_0 = "#45475A";
      terminal_color_1 = "#F38BA8";
      terminal_color_2 = "#A6E3A1";
      terminal_color_3 = "#F9E2AF";
      terminal_color_4 = "#89B4FA";
      terminal_color_5 = "#F5C2E7";
      terminal_color_6 = "#94E2D5";
      terminal_color_7 = "#BAC2DE";
      terminal_color_8 = "#45475A";
      terminal_color_9 = "#F38BA8";
      terminal_color_10 = "#A6E3A1";
      terminal_color_11 = "#F9E2AF";
      terminal_color_12 = "#89B4FA";
      terminal_color_13 = "#F5C2E7";
      terminal_color_14 = "#94E2D5";
      terminal_color_15 = "#BAC2DE";
    };

    maps = {
      normal = {
        "<C-t>" = {
          silent = true;
          action = "<CMD>lua require('FTerm').toggle()<CR>";
        };
        "<C-h>" = {
          silent = true;
          action = "<Plug>(cokeline-focus-prev)";
        };
        "<C-l>" = {
          silent = true;
          action = "<Plug>(cokeline-focus-next)";
        };
        "<A-j>" = {
          silent = true;
          noremap = true;
          action = ":MoveLine(1)<CR>";
        };
        "<A-k>" = {
          silent = true;
          noremap = true;
          action = ":MoveLine(-1)<CR>";
        };
        "<A-h>" = {
          silent = true;
          noremap = true;
          action = ":MoveHChar(-1)<CR>";
        };
        "<A-l>" = {
          silent = true;
          noremap = true;
          action = ":MoveHChar(1)<CR>";
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
          action = "<Plug>(cokeline-pick-close)";
        };
        "<Leader>bj" = {
          silent = true;
          action = "<Plug>(cokeline-pick-focus)";
        };
        "<Leader>e" = {
          silent = true;
          action = "<CMD>NvimTreeToggle<CR>";
        };
        "<Leader>a" = {
          silent = true;
          action = "<CMD>lua require('alternate-toggler').toggleAlternate()<CR>";
        };
      };

      visual = {
        "<A-j>" = {
          silent = true;
          noremap = true;
          action = ":MoveBlock(1)<CR>";
        };
        "<A-k>" = {
          silent = true;
          noremap = true;
          action = ":MoveBlock(-1)<CR>";
        };
        "<A-h>" = {
          silent = true;
          noremap = true;
          action = ":MoveHBlock(-1)<CR>";
        };
        "<A-l>" = {
          silent = true;
          noremap = true;
          action = ":MoveHBlock(1)<CR>";
        };
      };

      terminal."<C-t>" = {
        silent = true;
        action = "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>";
      };
    };

    extraConfigLua = ''
      vim.cmd("set mouse=a")
      vim.cmd("set guifont=CartographCF\\ Nerd\\ Font:h14")

      require("indent_blankline").setup {show_current_context = true, show_current_context_start = true}
      require("gitsigns").setup()
      require("colorizer").setup()
      require("FTerm").setup({border = "rounded", dimensions = {height = 0.9, width = 0.9}})
      require("leap").add_default_mappings()
      require("nu").setup({})

      require("catppuccin").setup({
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = { "italic" },
          keywords = {},
          strings = {},
          variables = { "italic" },
          numbers = {},
          booleans = { "italic" },
          properties = {},
          types = {},
          operators = {},
        }
      })

      local a = {
        blue = "#89b4fa",
        cyan = "#94e2d5",
        black = "#1e1e2e",
        white = "#cdd6f4",
        violet = "#cba6f7",
        grey = "#181d2d"
      }
      local b = {
        normal = {a = {fg = a.black, bg = a.violet}, b = {fg = a.white, bg = a.grey}, c = {fg = a.black, bg = a.black}},
        insert = {a = {fg = a.black, bg = a.blue}},
        visual = {a = {fg = a.black, bg = a.cyan}},
        replace = {a = {fg = a.black, bg = a.white}},
        inactive = {a = {fg = a.white, bg = a.black}, b = {fg = a.white, bg = a.black}, c = {fg = a.black, bg = a.black}}
      }
      local c = {
        function()
          return string.rep(" ", vim.api.nvim_win_get_width(require "nvim-tree.view".get_winnr()) - 1)
        end,
        cond = require("nvim-tree.view").is_visible, color = "NvimTreeNormal"
      }
      require("lualine").setup {
        options = {
            theme = b,
            component_separators = "|",
            section_separators = {left = "", right = ""},
            refresh = {statusline = 100, tabline = 100, winbar = 100}
        },
        sections = {
            lualine_a = {c, {"mode", separator = {left = ""}, right_padding = 2}},
            lualine_b = {"filename", "branch"},
            lualine_c = {"fileformat"},
            lualine_x = {"lsp_progress"},
            lualine_y = {"filetype", "progress"},
            lualine_z = {{"location", separator = {right = ""}, left_padding = 2}}
        },
        inactive_sections = {
            lualine_a = {"filename"},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {"location"}
        },
        tabline = {},
        extensions = {}
      }

      local d = require("cokeline/utils").get_hex
      local e = require("cokeline/mappings").is_picking_focus
      local f = require("cokeline/mappings").is_picking_close
      require("cokeline").setup({
        show_if_buffers_are_at_least = 2,
        default_hl = {
          fg = function(g)
            return g.is_focused and d("Normal", "fg") or d("Comment", "fg")
          end,
          bg = d("ColorColumn", "bg")
        },
        components = {
          {text = " ", bg = d("Normal", "bg")},
          {text = "", fg = d("ColorColumn", "bg"), bg = d("Normal", "bg")},
          {text = function(g)
                    if e() or f() then
                      return g.pick_letter .. " "
                    end
                    return g.devicon.icon
                  end,
           fg = function(g)
                  if e() then
                    return yellow
                  end
                  if f() then
                    return red
                  end
                  if g.is_focused then
                    return dark
                  else
                    return light
                  end
                end,
           style = function(h)
                    return (e() or f()) and "italic,bold" or nil
                   end
          },
          {text = " "},
          {text = function(g)
                    return g.filename .. "  "
                  end,
           style = function(g)
                   end
          },
          {text = "", delete_buffer_on_left_click = true},
          {text = "", fg = d("ColorColumn", "bg"), bg = d("Normal", "bg")}
        }
      })
    '';

    plugins = {
      comment-nvim.enable = true;
      cmp_luasnip.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      nvim-autopairs.enable = true;

      dashboard = {
        enable = true;
        center = [
          {
            icon = "  ";
            desc = "Find File                               ";
            shortcut = "SPC f f";
            action = "Telescope find_files";
          }
          {
            icon = "  ";
            desc = "Recently Used Files                     ";
            shortcut = "SPC f h";
            action = "Telescope oldfiles";
          }
          {
            icon = "  ";
            desc = "Find Word                               ";
            shortcut = "SPC f w";
            action = "Telescope live_grep";
          }
        ];
        header = [
          "          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          "
          "          ▜███▙       ▜███▙  ▟███▛          "
          "           ▜███▙       ▜███▙▟███▛           "
          "            ▜███▙       ▜██████▛            "
          "     ▟█████████████████▙ ▜████▛     ▟▙      "
          "    ▟███████████████████▙ ▜███▙    ▟██▙     "
          "           ▄▄▄▄▖           ▜███▙  ▟███▛     "
          "          ▟███▛             ▜██▛ ▟███▛      "
          "         ▟███▛               ▜▛ ▟███▛       "
          "▟███████████▛                  ▟██████████▙ "
          "▜██████████▛                  ▟███████████▛ "
          "      ▟███▛ ▟▙               ▟███▛          "
          "     ▟███▛ ▟██▙             ▟███▛           "
          "    ▟███▛  ▜███▙           ▝▀▀▀▀            "
          "    ▜██▛    ▜███▙ ▜██████████████████▛      "
          "     ▜▛     ▟████▙ ▜████████████████▛       "
          "           ▟██████▙       ▜███▙             "
          "          ▟███▛▜███▙       ▜███▙            "
          "         ▟███▛  ▜███▙       ▜███▙           "
          "         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘           "
        ];
      };

      lsp = {
        enable = true;
        onAttach = ''
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if client.name == "null-ls" then
                  local util = require 'vim.lsp.util'
                  local params = util.make_formatting_params({})
                  client.request('textDocument/formatting', params, nil, bufnr)
                end
                vim.lsp.buf.format({bufnr = bufnr})
              end,
            })
          end
        '';

        servers = {
          eslint.enable = true;
          rnix-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            settings.checkOnSave.command = "clippy";
          };
          tsserver.enable = true;
          gopls.enable = true;
          zls.enable = true;
        };
      };

      null-ls = {
        enable = true;
        sources = {
          formatting = {
            alejandra.enable = true;
          };
        };
      };

      nvim-cmp = {
        enable = true;

        formatting.format = ''
          require('lspkind').cmp_format({mode = 'symbol', maxwidth = 50})
        '';

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };

        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };

        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
        ];

        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
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
      pkgs.alternate-toggler-nvim
      pkgs.copilot-vim
      pkgs.move-nvim
      pkgs.nvim-cokeline
      pkgs.nvim-nu

      catppuccin-nvim
      FTerm-nvim
      gitsigns-nvim
      indent-blankline-nvim
      lazygit-nvim
      leap-nvim
      lspkind-nvim
      lualine-lsp-progress
      lualine-nvim
      luasnip
      markdown-preview-nvim
      nightfox-nvim
      nvim-colorizer-lua
      nvim-web-devicons
      presence-nvim
      trouble-nvim
      vim-cool
      vim-smoothie
      vim-visual-multi
      zen-mode-nvim
    ];
  };
}
