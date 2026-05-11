local m = require('core.mapper')
local ufn = require('utils.fn')
local icons = require('modules.ui.icons')
local M = {}

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
      folder_closed = ufn.pad_str(icons.fs.DirClosed),
      folder_open = ufn.pad_str(icons.fs.DirOpen),
      kind = ufn.pad_str(icons.kind),
   },
}

-- stylua: ignore
M.keys = {
   { '<leader>xc', m.cmd('Trouble symbols toggle focus=false win.position=right'), desc = '[trouble] LSP symbols' },
   { '<leader>xx', m.cmd('Trouble diagnostics toggle'),                            desc = '[trouble] Diagnostics' },
   { '<leader>xX', m.cmd('Trouble diagnostics toggle filter.buf=0'),               desc = '[trouble] Buffer Diagnostics' },
   { '<leader>xL', m.cmd('Trouble loclist toggle'),                                desc = '[trouble] Location List' },
   { '<leader>xQ', m.cmd('Trouble qflist toggle'),                                 desc = '[trouble] Quickfix List' },
}

return M
