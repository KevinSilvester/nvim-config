local ok, impatient = pcall(require, 'impatient')
if ok then
   impatient.enable_profile()
end

require('core.lua_globals')
local fs = require('utils.fs')
local cache_dir = vim.fn.stdpath('cache')

local setup_cache = function()
   local cache_dirs = {
      cache_dir .. '/backup',
      cache_dir .. '/session',
      cache_dir .. '/swap',
      cache_dir .. '/view',
      cache_dir .. '/undo',
   }

   for _, d in ipairs(cache_dirs) do
      if not fs.is_dir(d) then
         fs.mkdir(d)
      end
   end
end

-- load core
require('core.globals')
require('core.options')
require('core.autocmds')
require('core.cmds')
setup_cache()

-- setup keymaps
require('keymaps')

-- load plugins
require('core.pack').ensure_plugins()
require('core.pack').load_compile()

-- setup colorscheme and keymaps
require('modules.ui.colorscheme').setup('catppuccin')
