vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
vim.cmd('set guifont=Maple\\ Mono\\ SC\\ NF:h16')
vim.cmd('set mouse=a')

require('buffertabs').setup({ horizontal = 'right' })
require('telescope').load_extension('ui-select')
require('codeium').setup()
require('lsp-lens').setup()
require('renamer').setup({ empty = true })
require('dressing').setup()

require('FTerm').setup({
  border = 'rounded',
  dimensions = { height = 0.9, width = 0.9 },
})

require('feline').setup({
  components = require('catppuccin.groups.integrations.feline').get(),
})

require('searchbox').setup({
  popup = {
    position = {
      row = '10%',
      column = '100%',
    },
  },
})
