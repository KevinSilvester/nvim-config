local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

-- search tools
plugin({
   'nvim-telescope/telescope-fzf-native.nvim',
   opt = false,
   run = 'make',
})
plugin({
   'nvim-telescope/telescope.nvim',
   opt = true,
   cmd = 'Telescope',
   after = { 'plenary.nvim', 'popup.nvim', 'nvim-web-devicons', 'nvim-treesitter', 'nvim-notify' },
   config = conf.telescope,
})

-- keymap helper
plugin({
   'folke/which-key.nvim',
   config = conf.which_key,
})

-- terminal in neovim
plugin({
   'akinsho/toggleterm.nvim',
   opt = true,
   cmd = 'ToggleTerm',
   keys = '<C-P>',
   config = conf.toggleterm,
})

-- markdown preview
plugin({
   'iamcco/markdown-preview.nvim',
   opt = true,
   cmd = {
      'MarkdownPreview',
      'MarkdownPreviewStop',
      'MarkdownPreviewToggle',
   },
   run = 'cd app && npm i',
   setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
   end,
   ft = { 'markdown' },
   event = 'BufReadPost',
})

-- colour picker
plugin({
   'max397574/colortils.nvim',
   -- opt = true,
   event = 'BufReadPost',
   cmd = 'Colortils',
   config = conf.colortils,
})

-- icon picker
-- plugin({
--    'ziontee113/icon-picker.nvim',
--    opt = true,
--    event = 'BufReadPost',
--    cmd = {
--       'IconPickerNormal',
--       'IconPickerInsert',
--       'IconPickerYank',
--    },
--    config = conf.icon_picker,
-- })
