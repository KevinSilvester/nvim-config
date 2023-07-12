local ufs = require('utils.fs')

---@class CoreLazy
---@field root string
---@field lazypath string
---@field lockfile string
---@field spec { import: string }[]
local Lazy = {}

---Initialise Lazy
---@param root? string directory where plugins will be installed
---@param lockfile? string lockfile generated after running update.
function Lazy:init(root, lockfile)
   self = setmetatable({}, { __index = Lazy })
   self.root = root or ufs.path_join(PATH.data, 'lazy')
   self.lazypath = ufs.path_join(self.root, 'lazy.nvim')
   self.spec = {}

   if HOST.is_mac then
      self.lockfile = lockfile or ufs.path_join(PATH.config, 'lazy-lock.work.json')
   else
      self.lockfile = lockfile or ufs.path_join(PATH.config, 'lazy-lock.personal.json')
   end

   self:__load_spec()
   self:__bootstrap()
end

---Load the plugin specs from modules folder
function Lazy:__load_spec()
   local modules_dir = ufs.path_join(PATH.config, 'lua', 'modules')
   local match_pattern = 'lua/(.+).lua$'
   local imports = vim.fs.find('plugins.lua', { path = modules_dir, type = 'file', limit = 10 })

   if #imports == 0 then
      log.warn('core.lazy', 'No import modules were found')
      return
   end

   for idx, path in ipairs(imports) do
      self.spec[idx] = { import = string.match(path, match_pattern):gsub('/', '.') }
   end
end

---Bootstrap lazy.nvim
function Lazy:__bootstrap()
   if not ufs.is_dir(self.lazypath) then
      vim.fn.system({
         'git',
         'clone',
         '--branch=stable',
         'https://github.com/folke/lazy.nvim.git',
         self.lazypath,
      })
   end
   vim.opt.runtimepath:prepend(self.lazypath)
   vim.g.mapleader = ' '

   local ok, lazy = pcall(require, 'lazy')
   if not ok then
      log.error('core.lazy', 'Failed to install lazy')
      return
   end

   lazy.setup({
      root = self.root,
      lockfile = self.lockfile,
      -- spec = { { 'LazyVim/LazyVim', import = 'lazyvim.plugins' } },
      spec = self.spec,
      -- spec = { { import = 'modules._essentials.plugins' } },
      defaults = {
         lazy = true,
         version = false,
      },
      install = { colorscheme = { 'catppuccin', 'habamax' } },
      ui = { border = 'rounded' },
      checker = { enabled = false }, -- automatically check for plugin updates
      performance = {
         rtp = {
            disabled_plugins = {
               '2html_plugin',
               'getscript',
               'getscriptPlugin',
               'gzip',
               'logiPat',
               'matchit',
               'matchparen',
               'netrw',
               'netrwPlugin',
               'netrwSettings',
               'netrwFileHandlers',
               'rrhelper',
               'tar',
               'tarPlugin',
               'tohtml',
               'tutor',
               'vimball',
               'vimballPlugin',
               'zip',
               'zipPlugin',
            },
         },
      },
   })
end

return Lazy
