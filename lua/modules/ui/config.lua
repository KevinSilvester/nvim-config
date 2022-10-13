local config = {}

config.bufferline = function()
   require('modules.ui.config._bufferline')
end

config.dashboard = function()
   require('modules.ui.config._dashboard')
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

return config
