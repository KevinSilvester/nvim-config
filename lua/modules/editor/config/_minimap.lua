local utils = require('core.utils')

if utils.executable('code-minimap') then
   vim.notify(
      [[`code-mimimap` not found
Install on macOS/linux: `brew install code-minimap`,
Install on Windows: `scoop bucket add extras`, `scoop install code-minimap`,
Install from source: `cargo install --locked code-minimap`]],
      vim.log.levels.ERROR,
      { title = 'nvim-config' }
   )
   return
end

-- stylua: ignore
local colors = {
   kanagawa = {
      minimapDiffAdded = { guibg = "#1f1f28", guifg = "#76946a" },
      minimapDiffRemoved = { guibg = "#1f1f28", guifg = "#c34043" },
      minimapDiffLine = { guibg = "#1f1f28", guifg = "#dca561" },
      minimapCursor = { guibg = "#363646", guifg = "#7E9CD8" },
      minimapCursorDiffAdded = { guibg = "#363646", guifg = "#76946a" },
      minimapCursorDiffRemoved = { guibg = "#363646", guifg = "#c34043" },
      minimapCursorDiffLine = { guibg = "#363646", guifg = "#dca561" },
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
