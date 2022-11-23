local config = {}

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
