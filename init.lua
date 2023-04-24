-- load core
require('core.lua_globals')
require('core.logger'):init()
require('core.bootstrap'):init()
require('core.lazy'):init()

-- load config
require('config.globals')
require('config.options')
require('config.autocmds')
require('config.cmds')
require('config.keymaps')

require('modules.ui.colorscheme').setup('catppuccin')
