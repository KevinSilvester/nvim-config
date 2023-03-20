local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

-- file icons
plugin({ 'kyazdani42/nvim-web-devicons', opt = false })

-- colorschemes
plugin({ 'glepnir/zephyr-nvim' })
plugin({ 'folke/tokyonight.nvim' })
plugin({ 'lunarvim/darkplus.nvim' })
plugin({ 'lunarvim/onedarker.nvim' })
plugin({ 'rebelot/kanagawa.nvim' })
plugin({ 'marko-cerovac/material.nvim' })
plugin({ 'olimorris/onedarkpro.nvim' })
plugin({
   'olivercederborg/poimandres.nvim',
   config = function()
      require('poimandres').setup()
   end,
})
plugin({
   'catppuccin/nvim',
   as = 'catppuccin',
   config = function()
      require('catppuccin').setup()
   end,
})

-- statusline
plugin({
   'nvim-lualine/lualine.nvim',
   opt = true,
   after = { 'gitsigns.nvim', 'null-ls.nvim' },
   config = conf.statusline,
})

-- preview color
plugin({ 'NvChad/nvim-colorizer.lua' })

-- inputs
plugin({
   'stevearc/dressing.nvim',
   after = 'nui.nvim',
   config = conf.input,
})

-- command completion
plugin({
   'gelguy/wilder.nvim',
   config = conf.wilder,
})

-- indent
plugin({
   'lukas-reineke/indent-blankline.nvim',
   event = 'BufWinEnter',
   config = conf.indent,
})

-- git
plugin({
   'lewis6991/gitsigns.nvim',
   after = 'plenary.nvim',
   event = { 'BufReadPost', 'BufNewFile' },
   config = conf.gitsigns,
})

-- notifications
plugin({
   'rcarriga/nvim-notify',
   config = conf.notification,
   opt = false,
})

-- dashboard
plugin({
   'goolord/alpha-nvim',
   config = conf.dashboard,
   opt = true,
   event = 'BufWinEnter',
})

-- sidebar
plugin({
   'kyazdani42/nvim-tree.lua',
   commit = '0cd8ac4751c39440a1c28c6be4704f3597807d29',
   config = conf.sidebar,
   opt = true,
   cmd = { 'NvimTreeToggle', 'NvimTreeRefresh' },
})

-- bufferline
plugin({
   'akinsho/nvim-bufferline.lua',
   config = conf.bufferline,
   opt = true,
   event = 'BufWinEnter',
})
