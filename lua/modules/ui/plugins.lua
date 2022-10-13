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
   'catppuccin/nvim',
   as = 'catppuccin',
   config = function()
      require('catppuccin').setup()
   end,
})

-- notifications
plugin({
   "rcarriga/nvim-notify",
   config = conf.notification,
   opt = false
})

-- dashboard
plugin({
   "goolord/alpha-nvim",
   config = conf.dashboard,
   opt = true,
   event = "BufWinEnter"
})

-- sidebar
plugin({
   "kyazdani42/nvim-tree.lua",
   config = conf.sidebar,
   opt = true,
   cmd = { "NvimTreeToggle" }
})

-- bufferline
plugin({
   "akinsho/nvim-bufferline.lua",
   config = conf.bufferline,
   opt = true,
   event = "BufReadPost",
})

