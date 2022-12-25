local config = {}

config.colortils = function()
   require('modules.tools.config._colortils')
end

config.icon_picker = function()
   require('modules.tools.config._icon_picker')
end

config.telescope = function()
   require('modules.tools.config._telescope')
end

config.toggleterm = function()
   require('modules.tools.config._toggleterm')
end

config.which_key = function()
   require('modules.tools.config._which_key')
end

return config
