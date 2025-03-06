local cmd = require('core.mapper').cmd
local icons = require('modules.ui.icons')
local M = {}

---@param i string|string[]
---@return string|string[]
local function pad(i)
   if type(i) == 'string' then
      return i .. ' '
   end

   local i_padded = {}
   for k, v in pairs(i) do
      i_padded[k] = v .. ' '
   end
   return i_padded
end

M.opts = {
   icons = {
      indent = {
         top = '│ ',
         middle = '├╴',
         last = '╰╴',
         fold_open = ' ',
         fold_closed = ' ',
         ws = '  ',
      },
      folder_closed = pad(icons.fs.DirClosed),
      folder_open = pad(icons.fs.DirOpen),
      kind = pad(icons.kind),
   },
}

-- stylua: ignore
M.keys = {
   { '<leader>xc', cmd('Trouble symbols toggle focus=false win.position=right'), desc = '[trouble] LSP symbols' },
   { '<leader>xx', cmd('Trouble diagnostics toggle'),                            desc = '[trouble] Diagnostics' },
   { '<leader>xX', cmd('Trouble diagnostics toggle filter.buf=0'),               desc = '[trouble] Buffer Diagnostics' },
   { '<leader>xL', cmd('Trouble loclist toggle'),                                desc = '[trouble] Location List' },
   { '<leader>xQ', cmd('Trouble qflist toggle'),                                 desc = '[trouble] Quickfix List' },
}

return M
