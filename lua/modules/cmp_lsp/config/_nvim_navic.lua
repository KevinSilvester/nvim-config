local icons = require('modules.ui.icons').kind

for k, v in pairs(icons) do
   icons[k] = v .. ' '
end

require('nvim-navic').setup({
   icons = icons,
})
