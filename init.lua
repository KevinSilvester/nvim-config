local ok, impatient = pcall(require, 'impatient')
if ok then
   impatient.enable_profile()
end

local ufs = require('core.utils').fs
local cache_dir = vim.fn.stdpath('cache')

local createdir = function()
   local data_dir = {
      cache_dir .. '/backup',
      cache_dir .. '/session',
      cache_dir .. '/swap',
      cache_dir .. '/tags',
      cache_dir .. '/undo',
   }

   if not ufs.is_dir(cache_dir) then
      ufs.mkdir(cache_dir)
      for _, v in pairs(data_dir) do
         if not ufs.is_dir(v) then
            ufs.mkdir(v)
         end
      end
   end
end

createdir()

require('core.globals')
require('core.options')

if not pcall(vim.cmd, 'colorscheme catppuccin') then
   vim.notify('Failed to load colorscheme', vim.log.levels.ERROR, { title = 'nvim-config' })
end

require('core.autocmds')
require('core.cmds')
require('keymaps')

local pack = require('core.pack')
pack.ensure_plugins()
pack.load_compile()
