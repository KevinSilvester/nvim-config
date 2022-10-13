local plugin = require('core.pack').register_plugin
local conf = require('modules._essentials.config')

plugin({ 'nvim-lua/plenary.nvim' })
plugin({ 'nvim-lua/popup.nvim' })
plugin({ 'lewis6991/gitsigns.nvim', config = conf.gitsigns })
plugin({ 'lewis6991/impatient.nvim' })
