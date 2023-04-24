local M = {}

---set colorscheme
---@param colorscheme string|'catppuccin'|'kanagawa'|'material'|'tokyonight'|'zephyr'|'darkplus'|'onedarker'|'poimandres'
M.setup = function(colorscheme)
   xpcall(function()
      vim.cmd('colorscheme ' .. colorscheme)
   end, function()
      log.warn('modules.ui.colorscheme', 'colorscheme ' .. colorscheme .. ' not found!')
   end)
end

return M
