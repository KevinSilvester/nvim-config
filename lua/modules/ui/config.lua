local fn = vim.fn

local config = {}

config.bufferline = function()
   require('modules.ui.config._bufferline')
end

config.dashboard = function()
   require('modules.ui.config._dashboard')
end

config.indent = function()
   require('modules.ui.config._indent')
end

config.input = function()
   require('modules.ui.config._input')
end

config.gitsigns = function()
   require("modules.ui.config._gitsigns")
end

config.notification = function()
   require('modules.ui.config._notification')
end

config.sidebar = function()
   require('modules.ui.config._sidebar')
end

config.statusline = function()
   require('modules.ui.config._statusline')
end


-- local tmp = vim.split(fn.globpath(fn.stdpath("config") .. "/lua/modules/ui/config", "_*.lua"), "\n")
-- for _, f in ipairs(tmp) do
--    local mod_path = string.match(f, "lua/(.+).lua$")
--    local mod_name = mod_path:gsub("modules/ui/config/_", "")
--
--    config[mod_name] = function()
--       require(mod_path)
--    end
-- end

return config
