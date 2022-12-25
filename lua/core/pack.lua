local fn, uv, api = vim.fn, vim.loop, vim.api

-- dir paths
local config_dir = fn.stdpath('config')
local data_dir = string.format('%s/site/', fn.stdpath('data'))
local cache_dir = fn.stdpath('cache')
local modules_dir = config_dir .. (vim.g.is_win and '\\lua\\modules' or '/lua/modules')

-- packer info
local packer = nil
local packer_compiled = data_dir .. '/lua/packer_compiled.lua'
local bak_compiled = data_dir .. '/lua/bak_compiled.lua'

-- wrapper ar--
-- Packer wrapper
local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
   self.repos = {}

   local get_plugins_list = function()
      local list = {}
      local glob_pattern = vim.g.is_win and '*\\plugins.lua' or '*/plugins.lua'
      local match_pattern = vim.g.is_win and 'lua\\(.+).lua$' or 'lua/(.+).lua$'
      local tmp = vim.split(fn.globpath(modules_dir, glob_pattern), '\n', {})

      for _, f in ipairs(tmp) do
         list[#list + 1] = string.match(f, match_pattern)
      end

      return list
   end

   local plugins_file = get_plugins_list()
   for _, m in ipairs(plugins_file) do
      require(m)
   end
end

function Packer:load_packer()
   if not packer then
      api.nvim_command('packadd packer.nvim')
      packer = require('packer')
   end
   packer.init({
      compile_path = packer_compiled,
      git = { clone_timeout = 120 },
      disable_commands = true,
      display = {
         open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
         end,
         working_sym = 'ﰭ',
         error_sym = '',
         done_sym = '',
         removed_sym = '',
         moved_sym = 'ﰳ',
      },
   })
   packer.reset()
   local use = packer.use
   self:load_plugins()
   use({ 'wbthomason/packer.nvim', opt = true })
   for _, repo in ipairs(self.repos) do
      use(repo)
   end
end

function Packer:init_ensure_plugins()
   local packer_dir = data_dir .. 'pack/packer/opt/packer.nvim'
   local state = uv.fs_stat(packer_dir)
   if not state then
      local cmd = '!git clone https://github.com/wbthomason/packer.nvim ' .. packer_dir
      api.nvim_command(cmd)
      uv.fs_mkdir(data_dir .. 'lua', 511, function()
         assert('make compile path dir failed')
      end)
      self:load_packer()
      packer.sync()
   end
end

--
-- Wrapper inteface
local plugins = setmetatable({}, {
   __index = function(_, key)
      if key == 'Packer' then
         return Packer
      end
      if not packer then
         Packer:load_packer()
      end
      return packer[key]
   end,
})

function plugins.ensure_plugins()
   Packer:init_ensure_plugins()
end

function plugins.register_plugin(repo)
   if not Packer.repos then
      Packer.repos = {}
   end
   table.insert(Packer.repos, repo)
end

function plugins.auto_compile()
   local file = api.nvim_buf_get_name(0)
   if not file:match(config_dir) then
      return
   end

   if file:match('plugins.lua') then
      plugins.clean()
   end
   plugins.compile()
   require('packer_compiled')
end

function plugins.load_compile()
   if vim.fn.filereadable(packer_compiled) == 1 then
      require('packer_compiled')
   else
      vim.notify('Run PackerSync or PackerCompile', vim.log.levels.INFO, { title = 'Packer' })
   end

   local cmds = {
      'Compile',
      'Install',
      'Update',
      'Sync',
      'Clean',
      'Status',
   }
   for _, cmd in ipairs(cmds) do
      api.nvim_create_user_command('Packer' .. cmd, function()
         plugins[cmd:lower()]()
      end, {})
   end

   local PackerHooks = vim.api.nvim_create_augroup('PackerHooks', { clear = true })
   vim.api.nvim_create_autocmd('User', {
      group = PackerHooks,
      pattern = 'PackerCompileDone',
      callback = function()
         vim.notify('Compile Done!', vim.log.levels.INFO, { title = 'Packer' })
      end,
   })
end

return plugins
