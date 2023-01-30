{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  programs.nixvim = {
    enable = false;
    package = inputs.neovim.packages.${pkgs.system}.default;
    colorscheme = "carbonfox";

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
      catppuccin_flavor = "mocha";
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
      vim.cmd("set guifont=Maple\\ Mono\\ NF:h14")
      require("indent_blankline").setup {show_current_context = true, show_current_context_start = true}
      require("gitsigns").setup()
      require("colorizer").setup()
      require("FTerm").setup({border = "rounded", dimensions = {height = 0.9, width = 0.9}})
      require("leap").add_default_mappings()
      require("nu").setup {}
      local a = string.format
      local b = function(c)
          if c then
              return a("#%06x", c)
          end
      end
      local function d(e)
          if not e or e == "NONE" then
              return {}
          end
          local f = {}
          for g in string.gmatch(e, "([^,]+)") do
              f[g] = true
          end
          return f
      end
      local function h(i)
          local j = vim.api.nvim_get_hl_by_name(i, true)
          if j.link then
              return h(j.link)
          end
          local f = d(j.style)
          f.fg = j.foreground and b(j.foreground)
          f.bg = j.background and b(j.background)
          f.sp = j.special and b(j.special)
          return f
      end
      local function k(l)
          for m, n in pairs(l) do
              vim.api.nvim_set_hl(0, m, n)
          end
      end
      local function o()
          local p = {
              black = {index = 0, default = "#393b44"},
              red = {index = 1, default = "#c94f6d"},
              green = {index = 2, default = "#81b29a"},
              yellow = {index = 3, default = "#dbc074"},
              blue = {index = 4, default = "#719cd6"},
              magenta = {index = 5, default = "#9d79d6"},
              cyan = {index = 6, default = "#63cdcf"},
              white = {index = 7, default = "#dfdfe0"}
          }
          local q = {
              hint = {hl = "DiagnosticHint", default = p.green.default},
              info = {hl = "DiagnosticInfo", default = p.blue.default},
              warn = {hl = "DiagnosticWarn", default = p.yellow.default},
              error = {hl = "DiagnosticError", default = p.red.default}
          }
          local r = {}
          for i, s in pairs(p) do
              local t = "terminal_color_" .. s.index
              r[i] = vim.g[t] and vim.g[t] or s.default
          end
          for i, s in pairs(q) do
              r[i] = h(s.hl).fg or s.default
          end
          r.sl = h("StatusLine")
          r.sel = h("TabLineSel")
          return r
      end
      _G._generate_user_statusline_highlights = function()
          local u = o()
          local v = {
              Black = {fg = u.black, bg = u.white},
              Red = {fg = u.red, bg = u.sl.bg},
              Green = {fg = u.green, bg = u.sl.bg},
              Yellow = {fg = u.yellow, bg = u.sl.bg},
              Blue = {fg = u.blue, bg = u.sl.bg},
              Magenta = {fg = u.magenta, bg = u.sl.bg},
              Cyan = {fg = u.cyan, bg = u.sl.bg},
              White = {fg = u.white, bg = u.black}
          }
          local w = {}
          for i, s in pairs(v) do
              w["User" .. i] = {fg = s.fg, bg = s.bg, bold = true}
              w["UserRv" .. i] = {fg = s.bg, bg = s.fg, bold = true}
          end
          local x = vim.o.background == "dark" and {fg = u.black, bg = u.white} or {fg = u.white, bg = u.black}
          local l = {
              UserSLHint = {fg = u.sl.bg, bg = u.hint, bold = true},
              UserSLInfo = {fg = u.sl.bg, bg = u.info, bold = true},
              UserSLWarn = {fg = u.sl.bg, bg = u.warn, bold = true},
              UserSLError = {fg = u.sl.bg, bg = u.error, bold = true},
              UserSLStatus = {fg = x.fg, bg = x.bg, bold = true},
              UserSLFtHint = {fg = u.sel.bg, bg = u.hint},
              UserSLHintInfo = {fg = u.hint, bg = u.info},
              UserSLInfoWarn = {fg = u.info, bg = u.warn},
              UserSLWarnError = {fg = u.warn, bg = u.error},
              UserSLErrorStatus = {fg = u.error, bg = x.bg},
              UserSLStatusBg = {fg = x.bg, bg = u.sl.bg},
              UserSLAlt = u.sel,
              UserSLAltSep = {fg = u.sl.bg, bg = u.sel.bg},
              UserSLGitBranch = {fg = u.yellow, bg = u.sl.bg}
          }
          k(vim.tbl_extend("force", w, l))
      end
      _generate_user_statusline_highlights()
      vim.api.nvim_create_augroup("UserStatuslineHighlightGroups", {clear = true})
      vim.api.nvim_create_autocmd(
          {"SessionLoadPost", "ColorScheme"},
          {callback = function()
                  _generate_user_statusline_highlights()
              end}
      )
      local y = {
          text = {
              n = "NORMAL",
              no = "NORMAL",
              i = "INSERT",
              v = "VISUAL",
              V = "V-LINE",
              [""] = "V-BLOCK",
              c = "COMMAND",
              cv = "COMMAND",
              ce = "COMMAND",
              R = "REPLACE",
              Rv = "REPLACE",
              s = "SELECT",
              S = "SELECT",
              [""] = "SELECT",
              t = "TERMINAL"
          },
          colors = {
              n = "UserRvCyan",
              no = "UserRvCyan",
              i = "UserSLStatus",
              v = "UserRvMagenta",
              V = "UserRvMagenta",
              [""] = "UserRvMagenta",
              R = "UserRvRed",
              Rv = "UserRvRed",
              r = "UserRvBlue",
              rm = "UserRvBlue",
              s = "UserRvMagenta",
              S = "UserRvMagenta",
              [""] = "FelnMagenta",
              c = "UserRvYellow",
              ["!"] = "UserRvBlue",
              t = "UserRvBlue"
          },
          sep = {
              n = "UserCyan",
              no = "UserCyan",
              i = "UserSLStatusBg",
              v = "UserMagenta",
              V = "UserMagenta",
              [""] = "UserMagenta",
              R = "UserRed",
              Rv = "UserRed",
              r = "UserBlue",
              rm = "UserBlue",
              s = "UserMagenta",
              S = "UserMagenta",
              [""] = "FelnMagenta",
              c = "UserYellow",
              ["!"] = "UserBlue",
              t = "UserBlue"
          }
      }
      local z = {
          locker = "",
          page = "☰",
          line_number = "",
          connected = "",
          dos = "",
          unix = "",
          mac = "",
          mathematical_L = "𝑳",
          vertical_bar = "┃",
          vertical_bar_thin = "│",
          left = "",
          right = "",
          block = "█",
          left_filled = "",
          right_filled = "",
          slant_left = "",
          slant_left_thin = "",
          slant_right = "",
          slant_right_thin = "",
          slant_left_2 = "",
          slant_left_2_thin = "",
          slant_right_2 = "",
          slant_right_2_thin = "",
          left_rounded = "",
          left_rounded_thin = "",
          right_rounded = "",
          right_rounded_thin = "",
          circle = "●"
      }
      local function A(B)
          local C = vim.diagnostic.get(0, {severity = vim.diagnostic.severity[B]})
          local D = #C
          return D > 0 and " " .. D .. " " or ""
      end
      local function E()
          return y.colors[vim.fn.mode()] or "UserSLViBlack"
      end
      local function F()
          return y.sep[vim.fn.mode()] or "UserSLBlack"
      end
      local function G()
          local H = {}
          if vim.bo.readonly then
              table.insert(H, "🔒")
          end
          if vim.bo.modified then
              table.insert(H, "●")
          end
          table.insert(H, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:."))
          return table.concat(H, " ")
      end
      local I = {
          vimode = {provider = function()
                  return a(" %s ", y.text[vim.fn.mode()])
              end, hl = E, right_sep = {str = " ", hl = F}},
          gitbranch = {
              provider = "git_branch",
              icon = " ",
              hl = "UserSLGitBranch",
              right_sep = {str = "  ", hl = "UserSLGitBranch"},
              enabled = function()
                  return vim.b.gitsigns_status_dict ~= nil
              end
          },
          file_type = {provider = function()
                  return a(" %s ", vim.bo.filetype:upper())
              end, hl = "UserSLAlt"},
          fileinfo = {
              provider = {name = "file_info", opts = {type = "relative"}},
              hl = "UserSLAlt",
              left_sep = {str = " ", hl = "UserSLAltSep"},
              right_sep = {str = " ", hl = "UserSLAltSep"}
          },
          file_enc = {provider = function()
                  local J = z[vim.bo.fileformat] or ""
                  return a(" %s %s ", J, vim.bo.fileencoding)
              end, hl = "StatusLine", left_sep = {str = z.left_filled, hl = "UserSLAltSep"}},
          cur_position = {provider = function()
                  return a(" %3d:%-2d ", unpack(vim.api.nvim_win_get_cursor(0)))
              end, hl = E, left_sep = {str = z.left_filled, hl = F}},
          cur_percent = {provider = function()
                  return " " .. require("feline.providers.cursor").line_percentage() .. "  "
              end, hl = E, left_sep = {str = z.left, hl = E}},
          default = {provider = "", hl = "StatusLine"},
          lsp_status = {
              provider = function()
                  return vim.tbl_count(vim.lsp.buf_get_clients(0)) == 0 and "" or " ◦ "
              end,
              hl = "UserSLStatus",
              left_sep = {str = "", hl = "UserSLStatusBg", always_visible = true},
              right_sep = {str = "", hl = "UserSLErrorStatus", always_visible = true}
          },
          lsp_error = {provider = function()
                  return A("ERROR")
              end, hl = "UserSLError", right_sep = {str = "", hl = "UserSLWarnError", always_visible = true}},
          lsp_warn = {provider = function()
                  return A("WARN")
              end, hl = "UserSLWarn", right_sep = {str = "", hl = "UserSLInfoWarn", always_visible = true}},
          lsp_info = {provider = function()
                  return A("INFO")
              end, hl = "UserSLInfo", right_sep = {str = "", hl = "UserSLHintInfo", always_visible = true}},
          lsp_hint = {provider = function()
                  return A("HINT")
              end, hl = "UserSLHint", right_sep = {str = "", hl = "UserSLFtHint", always_visible = true}},
          in_fileinfo = {provider = "file_info", hl = "StatusLine"},
          in_position = {provider = "position", hl = "StatusLine"},
          file_winbar = {provider = G, hl = "Comment"}
      }
      local K = {
          {I.vimode, I.gitbranch, I.fileinfo, I.default},
          {
              I.lsp_status,
              I.lsp_error,
              I.lsp_warn,
              I.lsp_info,
              I.lsp_hint,
              I.file_type,
              I.file_enc,
              I.cur_position,
              I.cur_percent
          }
      }
      local L = {{I.in_fileinfo}, {I.in_position}}
      require("feline").setup(
          {
              components = {active = K, inactive = L},
              highlight_reset_triggers = {},
              force_inactive = {
                  filetypes = {
                      "NvimTree",
                      "packer",
                      "dap-repl",
                      "dapui_scopes",
                      "dapui_stacks",
                      "dapui_watches",
                      "dapui_repl",
                      "LspTrouble",
                      "qf",
                      "help"
                  },
                  buftypes = {"terminal"},
                  bufnames = {}
              },
              disable = {filetypes = {"dashboard", "startify"}}
          }
      )
      local a = string.format
      local b = function(c)
          if c then
              return a("#%06x", c)
          end
      end
      local function d(e)
          if not e or e == "NONE" then
              return {}
          end
          local f = {}
          for g in string.gmatch(e, "([^,]+)") do
              f[g] = true
          end
          return f
      end
      local function h(i)
          local j = vim.api.nvim_get_hl_by_name(i, true)
          if j.link then
              return h(j.link)
          end
          local f = d(j.style)
          f.fg = j.foreground and b(j.foreground)
          f.bg = j.background and b(j.background)
          f.sp = j.special and b(j.special)
          return f
      end
      local function k(l)
          for m, n in pairs(l) do
              vim.api.nvim_set_hl(0, m, n)
          end
      end
      local function o()
          local p = {
              black = {index = 0, default = "#393b44"},
              red = {index = 1, default = "#c94f6d"},
              green = {index = 2, default = "#81b29a"},
              yellow = {index = 3, default = "#dbc074"},
              blue = {index = 4, default = "#719cd6"},
              magenta = {index = 5, default = "#9d79d6"},
              cyan = {index = 6, default = "#63cdcf"},
              white = {index = 7, default = "#dfdfe0"}
          }
          local r = {}
          for i, s in pairs(p) do
              local t = "terminal_color_" .. s.index
              r[i] = vim.g[t] and vim.g[t] or s.default
          end
          r.sl = h("StatusLine")
          r.tab = h("TabLine")
          r.sel = h("TabLineSel")
          r.fill = h("TabLineFill")
          return r
      end
      _G._genreate_user_tabline_highlights = function()
          local u = o()
          local v = {
              Black = {fg = u.black, bg = u.white},
              Red = {fg = u.red, bg = u.sl.bg},
              Green = {fg = u.green, bg = u.sl.bg},
              Yellow = {fg = u.yellow, bg = u.sl.bg},
              Blue = {fg = u.blue, bg = u.sl.bg},
              Magenta = {fg = u.magenta, bg = u.sl.bg},
              Cyan = {fg = u.cyan, bg = u.sl.bg},
              White = {fg = u.white, bg = u.black}
          }
          local w = {}
          for i, s in pairs(v) do
              w["User" .. i] = {fg = s.fg, bg = s.bg, bold = true}
              w["UserRv" .. i] = {fg = s.bg, bg = s.fg, bold = true}
          end
          local l = {
              UserTLHead = {fg = u.fill.bg, bg = u.cyan},
              UserTLHeadSep = {fg = u.cyan, bg = u.fill.bg},
              UserTLActive = {fg = u.sel.fg, bg = u.sel.bg, bold = true},
              UserTLActiveSep = {fg = u.sel.bg, bg = u.fill.bg},
              UserTLBoldLine = {fg = u.tab.fg, bg = u.tab.bg, bold = true},
              UserTLLineSep = {fg = u.tab.bg, bg = u.fill.bg}
          }
          k(vim.tbl_extend("force", w, l))
      end
      _genreate_user_tabline_highlights()
      vim.api.nvim_create_augroup("UserTablineHighlightGroups", {clear = true})
      vim.api.nvim_create_autocmd(
          {"SessionLoadPost", "ColorScheme"},
          {callback = function()
                  _genreate_user_tabline_highlights()
              end}
      )
      local M = require("tabby.filename")
      local N = function()
          return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
      end
      local O = {
          hl = "TabLineFill",
          layout = "active_wins_at_tail",
          head = {{N, hl = "UserTLHead"}, {"", hl = "UserTLHeadSep"}},
          active_tab = {label = function(P)
                  return {"  " .. P .. " ", hl = "UserTLActive"}
              end, left_sep = {"", hl = "UserTLActiveSep"}, right_sep = {"", hl = "UserTLActiveSep"}},
          inactive_tab = {label = function(P)
                  return {"  " .. P .. " ", hl = "UserTLBoldLine"}
              end, left_sep = {"", hl = "UserTLLineSep"}, right_sep = {"", hl = "UserTLLineSep"}},
          top_win = {label = function(Q)
                  return {"  " .. M.unique(Q) .. " ", hl = "TabLine"}
              end, left_sep = {"", hl = "UserTLLineSep"}, right_sep = {"", hl = "UserTLLineSep"}},
          win = {label = function(Q)
                  return {"  " .. M.unique(Q) .. " ", hl = "TabLine"}
              end, left_sep = {"", hl = "UserTLLineSep"}, right_sep = {"", hl = "UserTLLineSep"}},
          tail = {{"", hl = "UserTLHeadSep"}, {"  ", hl = "UserTLHead"}}
      }
      require("tabby").setup({tabline = O})
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
          rust-analyzer.enable = true;
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
      pkgs.nvim-nu

      catppuccin-nvim
      feline-nvim
      FTerm-nvim
      gitsigns-nvim
      indent-blankline-nvim
      lazygit-nvim
      leap-nvim
      lspkind-nvim
      luasnip
      markdown-preview-nvim
      nightfox-nvim
      nvim-colorizer-lua
      nvim-web-devicons
      presence-nvim
      tabby-nvim
      trouble-nvim
      vim-cool
      vim-smoothie
      vim-visual-multi
      zen-mode-nvim
    ];
  };
}
