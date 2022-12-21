vim.cmd('set mouse=a')
vim.cmd('set guifont=Maple\\ Mono\\ NF:h12')
local colors = {
  blue   = '#89b4fa',
  cyan   = '#94e2d5',
  black  = '#141421',
  white  = '#cdd6f4',
  violet = '#cba6f7',
  grey   = '#181d2d',
}
local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.white } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}
local nvim_tree_shift =  {
  function ()
    return string.rep(' ', vim.api.nvim_win_get_width(require'nvim-tree.view'.get_winnr()) - 1)
  end,
  cond = require('nvim-tree.view').is_visible,
  color = 'NvimTreeNormal'
}
require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {
      nvim_tree_shift,
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = { 'lsp_progress' },
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
require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}
require('gitsigns').setup()
require('colorizer').setup()
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
require('FTerm').setup({
  border     = 'rounded',
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
})
require('leap').add_default_mappings()
