local ok, impatient = pcall(require, 'impatient')
if ok then
   impatient.enable_profile()
end

local fs = require('utils.fs')
local cache_dir = vim.fn.stdpath('cache')

local createdir = function()
   local cache_dirs = {
      cache_dir .. '/backup',
      cache_dir .. '/session',
      cache_dir .. '/swap',
      cache_dir .. '/tags',
      cache_dir .. '/undo',
   }

   for _, d in ipairs(cache_dirs) do
      if not fs.is_dir(d) then
         fs.mkdir(d)
      end
   end
end

createdir()

-- load core
require('core.globals')
require('core.options')
require('core.autocmds')
require('core.cmds')

-- load plugins
local pack = require('core.pack')
pack.ensure_plugins()
pack.load_compile()

-- setup colorscheme and keymaps
require('modules.ui.colorscheme').setup('catppuccin')
require('keymaps')
