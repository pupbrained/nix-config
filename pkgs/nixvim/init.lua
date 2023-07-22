require('telescope').load_extension 'ui-select'

require('catppuccin').setup {
  flavour = 'mocha',
  color_overrides = {
    mocha = {
      base = '#1e1e2f',
    },
  },
  styles = {
    properties = { 'italic' },
    operators = { 'bold' },
  },
}

vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
vim.cmd.colorscheme 'catppuccin'
vim.cmd 'set guifont=IosevkaNerdFont\\ Nerd\\ Font:h18'
vim.cmd 'set mouse=a'

require('nvim-lightbulb').setup { autocmd = { enabled = true } }
require('fidget').setup()
require('gitsigns').setup()
require('indent_blankline').setup()
require('mini.starter').setup()
require('mini.trailspace').setup()
require('mini.surround').setup()
require('mini.move').setup()
require('octo').setup()
require('overseer').setup()
require('renamer').setup {
  empty = true,
}

require('barbecue').setup {}

require('colorizer').setup {
  user_default_options = {
    names = false,
    mode = 'virtualtext',
  },
}

require('feline').setup {
  components = require('catppuccin.groups.integrations.feline').get(),
}

require('FTerm').setup {
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
}

require('illuminate').configure {
  min_count_to_highlight = 2,
}

require('mini.indentscope').setup {
  symbol = '│',
  draw = {
    delay = 50,
  },
}

require('mini.jump2d').setup {
  mappings = {
    start_jumping = 's',
  },
}

require('nvim-treesitter.configs').setup {
  rainbow = {
    enable = true,
    query = 'rainbow-parens',
    strategy = require('ts-rainbow').strategy.global,
    disable = { 'tsx' },
  },
}

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
  pattern = 'NvimTree',
})

vim.keymap.set('i', '<C-j>', function()
  return vim.fn['codeium#Accept']()
end, { expr = true })
