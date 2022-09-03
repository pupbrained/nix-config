vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 0
vim.o.tabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.g.mapleader = ' '
vim.g.astro_typescript = 'enable'
vim.o.showmode = false
vim.cmd('set mouse=a')
vim.cmd('set guifont=Rec\\ Mono\\ Casual:h13')
vim.g.catppuccin_flavour = "mocha"
require("catppuccin").setup()
vim.cmd [[colorscheme catppuccin]]

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
    f = { "<cmd>DashboardFindFile<cr>", "Find File" },
    h = { "<cmd>DashboardFindHistory<cr>", "Find History" },
    a = { "<cmd>DashboardFindWord<cr>", "Find Word" },
  },
  b = {
    name = "Buffer",
    e = { "<Plug>(cokeline-pick-close)", "Close" },
    j = { "<Plug>(cokeline-pick-focus)", "Focus" },
  },
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    k = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
  },
}, { prefix = "<Leader>" })

vim.keymap.set('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

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

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

require('telescope').load_extension('fzf')
require('nvim-autopairs').setup {}

local get_hex = require('cokeline/utils').get_hex
local is_picking_focus = require("cokeline/mappings").is_picking_focus
local is_picking_close = require("cokeline/mappings").is_picking_close

require('cokeline').setup({
  show_if_buffers_are_at_least = 2,
  default_hl = {
    fg = function(buffer)
      return buffer.is_focused
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

require 'FTerm'.setup({
  border     = 'double',
  dimensions = {
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

vim.opt.completeopt = "menu,menuone,noselect"

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, server in ipairs({ "rnix", "rust_analyzer", "astro" }) do
  require('lspconfig')[server].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.formatting_sync(nil, 2000)
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
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.formatting_sync(nil, 2000)
        end,
      })
    end
  end
})

require("nvim-tree").setup({
  filters = {
    dotfiles = true,
  },
})
