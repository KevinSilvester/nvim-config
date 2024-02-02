local ufs = require('utils.fs')

---@class Core.Lazy
---@field root string
---@field lazypath string
---@field lockfile string
---@field spec { import: string }[]
local Lazy = {}
Lazy.__index = Lazy

---Initialise Lazy
---@private
function Lazy:init()
   local lazy_root = ufs.path_join(PATH.data, 'lazy')
   local lazy_lockfile = ufs.path_join(PATH.config, 'lazy-lock.personal.json')

   if HOST.is_mac then
      lazy_lockfile = ufs.path_join(PATH.config, 'lazy-lock.work.json')
   end

   local lazy = setmetatable({
      root = lazy_root,
      lazypath = ufs.path_join(lazy_root, 'lazy.nvim'),
      lockfile = lazy_lockfile,
      spec = {},
   }, self)

   return lazy
end

---Start lazy.nvim
---@param root? string directory where plugins will be installed
---@param lockfile? string lockfile generated after running update.
function Lazy:start(root, lockfile)
   if type(root) == 'string' then
      self.root = root
   end

   if type(lockfile) == 'string' then
      self.lockfile = lockfile
   end

   self:__load_spec()
   self:__bootstrap()
   self:__setup()
end

---Load the plugin specs from modules folder
---@private
function Lazy:__load_spec()
   local modules_dir = ufs.path_join(PATH.config, 'lua', 'modules')
   local match_pattern = 'lua/(.+).lua$'
   local imports = vim.fs.find('plugins.lua', { path = modules_dir, type = 'file', limit = 10 })

   if #imports == 0 then
      log:warn('core.lazy', 'No import modules were found')
      return
   end

   for idx, path in ipairs(imports) do
      local module_name = string.match(path, match_pattern):gsub('/', '.')
      self.spec[idx] = { import = string.match(path, match_pattern):gsub('/', '.') }
   end
end

---Bootstrap lazy.nvim
---@private
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
end

---Setup lazy.nvim
---@private
function Lazy:__setup()
   local ok, lazy = pcall(require, 'lazy')
   if not ok then
      log:error('core.lazy', 'Failed to install lazy')
      return
   end

   lazy.setup({
      root = self.root,
      lockfile = self.lockfile,
      -- spec = { { 'LazyVim/LazyVim', import = 'lazyvim.plugins' } },
      spec = self.spec,
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

local lazy_ = Lazy:init()
return lazy_
