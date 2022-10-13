local fn, uv, api = vim.fn, vim.loop, vim.api

-- dir paths
local config_dir = fn.stdpath("config")
local data_dir = fn.stdpath("data")
local cache_dir = fn.stdpath("cache")
local modules_dir = config_dir .. "/lua/modules"

-- packer info
local packer = nil
local packer_compiled = data_dir .. "/lua/packer_compiled.lua"
local bak_compiled = data_dir .. "/lua/bak_compiled.lua"


-- wrapper around packer
local Packer = {}
Packer.__index = Packer

function Packer:load_plugin()
   self.repos = {}

  local get_plugins_list = function()
      local list = {}
      local tmp = vim.split(fn.globpath(modules_dir, "*/plugins.lua"), "\n")
      for _, f in ipairs(tmp) do
         list[#list + 1] = string.match(f, "lua/(.+).lua$")
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
      api.nvim_command("packadd packer.nvim")
      packer = require("packer")
   end
   packer.init({
      compile_path = packer_compiled,
      git = { clone_timeout = 120 },
      max_jobs = 40,
      disable_commands = true,
      display = {
         open_fn = function()
            return require("packer.util").float({ border = "rounded" })
         end,
         working_sym = "ﰭ",
         error_sym = "",
         done_sym = "",
         removed_sym = "",
         moved_sym = "ﰳ",
      },
   })
   packer.reset()
   local use = packer.use
   self:load_plugins()
   use({ "wbthomason/packer.nvim", opt = true })
   for _, repo in ipairs(self.repos) do
      use(repo)
   end
end

function Packer:init_ensure_plugins()
   local packer_dir = data_dir .. "pack/packer/opt/packer.nvim"
   local state = uv.fs_stat(packer_dir)
   if not state then
      local cmd = "!git clone https://github.com/wbthomason/packer.nvim " .. packer_dir
      api.nvim_command(cmd)
      uv.fs_mkdir(data_dir .. "lua", 511, function()
         assert("make compile path dir failed")
      end)
      self:load_packer()
      packer.sync()
   end
end

-- wrapper interface
local plugins = setmetatable({}, {
   __index = function(_, key)
      if key == "Packer" then
         return Packer
      end
      if not packer then
         Packer:load_packer()
      end
      return packer[key]
   end,
})

plugins.ensure_plugins = function()
   Packer:init_ensure_plugins()
end

plugins.bak_compile = function()
	if fn.filereadable(packer_compiled) == 1 then
		os.rename(packer_compiled, bak_compiled)
	end
	plugins.compile()
	vim.notify("Compile Done!", vim.log.levels.INFO, { title = "Packer" })
end

plugins.auto_compile = function()
   local file = vim.fn.expand("%:p")
	if file:match(modules_dir) then
		plugins.clean()
		plugins.bak_compile()
	end
   require("packer_compiled")
end

plugins.load_compile = function ()
   if fn.filereadable(packer_compiled) == 1 then
      require("packer_compiled")
   else
      plugins.bak_compile()
   end

   local cmds = { "Compile", "Install", "Update", "Sync", "Clean", "Status" }
   for _, cmd in ipairs(cmds) do
      api.nvim_create_user_command("Packer" .. cmd, function()
         plugins[cmd == "Compile" and "bak_compile" or cmd:lower()]()
		end, { force = true })
   end

   local PackerHooks = vim.api.nvim_create_augroup("PackerHooks", { clear = true })
   vim.api.nvim_create_autocmd("User", {
      group = PackerHooks,
      pattern = "PackerCompileDone",
      callback = function()
         plugins.bak_compile()
      end,
   })
end
