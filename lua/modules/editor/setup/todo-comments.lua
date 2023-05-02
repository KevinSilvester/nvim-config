local cmd = require('core.mapper').cmd
local M = {}

M.opts = {
   keywords = {
      FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      TEST = { icon = 'ﭧ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
   },
   gui_style = {
      fg = 'BOLD', -- The gui style to use for the fg highlight group.
      bg = 'NONE', -- The gui style to use for the bg highlight group.
   },
}

-- stylua: ignore
M.keys = {
   { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next todo comment', },
   { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment', },
   { '<leader>xt', cmd('TodoTrouble'),                                  desc = 'Todo (Trouble)' },
   { '<leader>xT', cmd('TodoTrouble keywords=TODO,FIX,FIXME'),          desc = 'Todo/Fix/Fixme (Trouble)' },
   { '<leader>st', cmd('TodoTelescope'),                                desc = 'Todo' },
   { '<leader>sT', cmd('TodoTelescope keywords=TODO,FIX,FIXME'),        desc = 'Todo/Fix/Fixme' },
}

return M
