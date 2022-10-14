-- stylua: ignore
local colors = {
   kanagawa = {
      minimapDiffAdded =         { guibg = "#1f1f28", guifg = "#76946a" },
      minimapDiffRemoved =       { guibg = "#1f1f28", guifg = "#c34043" },
      minimapDiffLine =          { guibg = "#1f1f28", guifg = "#dca561" },
      minimapCursor =            { guibg = "#363646", guifg = "#7E9CD8" },
      minimapCursorDiffAdded =   { guibg = "#363646", guifg = "#76946a" },
      minimapCursorDiffRemoved = { guibg = "#363646", guifg = "#c34043" },
      minimapCursorDiffLine =    { guibg = "#363646", guifg = "#dca561" },
   },
}

local current_colorscheme = vim.g.colors_name

-- check if colorscheme is supported
if colors[current_colorscheme] then
   for key, value in pairs(colors[current_colorscheme]) do
      local str = string.gsub('guifg=$guifg guibg=$guibg', '%$(%w+)', value)
      vim.cmd('autocmd BufEnter * :highlight ' .. key .. ' ctermbg=59  ctermfg=228 ' .. str)
   end
end
