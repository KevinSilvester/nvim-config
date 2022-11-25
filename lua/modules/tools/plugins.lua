local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

-- search tools
plugin({
   'nvim-telescope/telescope.nvim',
   cmd = 'Telescope',
   config = conf.telescope,
   after = { 'plenary.nvim', 'popup.nvim', 'nvim-web-devicons', 'nvim-treesitter', 'nvim-notify' },
   requires = {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
   },
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
