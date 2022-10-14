local config = {}

config.accelerated_jk = function()
   require('modules.editor.config._accelerated_jk')
end

config.auto_session = function()
   require('modules.editor.config._auto_session')
end

config.better_escape = function()
   require('modules.editor.config._better_escape')
end

config.comment = function()
   require('modules.editor.config._comment')
end

config.crates = function()
   require('modules.editor.config._crates')
end

config.dap = function()
   require('modules.editor.config._dap')
end

config.dapui = function()
   require('modules.editor.config._dapui')
end

config.diffview = function()
   require('modules.editor.config._diffview')
end

config.hop = function()
   require('modules.editor.config._hop')
end

config.illuminate = function()
   require('modules.editor.config._illuminate')
end

config.minimap = function()
   require('modules.editor.config._minimap')
end

config.neoscroll = function()
   require('modules.editor.config._neoscroll')
end

config.nvim_treesitter = function()
   require('modules.editor.config._nvim_treesitter')
end

config.package_info = function()
   require('modules.editor.config._package_info')
end

config.project = function()
   require('modules.editor.config._project')
end

config.specs = function()
   require('modules.editor.config._specs')
end

config.spectre = function()
   require('modules.editor.config._spectre')
end

config.tabout = function()
   require('modules.editor.config._tabout')
end

config.todo_comment = function()
   require('modules.editor.config._todo_comment')
end

return config
