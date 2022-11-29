local M = {}

---set colorscheme
---@param colorscheme string|'catppuccin'|'kanagawa'|'material'|'tokyonight'|'zephyr'|'darkplus'|'onedarker'|'poimandres'
M.setup = function(colorscheme)
   local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
   if not status_ok then
      vim.notify('colorscheme ' .. colorscheme .. ' not found!')
      return
   end
end

return M
