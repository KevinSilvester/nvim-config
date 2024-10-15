local i = require('modules.ui.icons')
local cmd = require('core.mapper').cmd
local M = {}

local function icon(name)
   return i.todo[name] .. ' '
end

M.opts = {
   keywords = {
      FIX = { icon = icon('Fix'), color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = icon('Todo'), color = 'info' },
      HACK = { icon = icon('Hack'), color = 'warning' },
      WARN = { icon = icon('Warn'), color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = icon('Perf'), alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = icon('Note'), color = 'hint', alt = { 'INFO' } },
      TEST = { icon = icon('Test'), color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
   },
   gui_style = {
      fg = 'BOLD', -- The gui style to use for the fg highlight group.
      bg = 'NONE', -- The gui style to use for the bg highlight group.
   },
}

-- stylua: ignore
M.keys = {
   { ']t',         function() require('todo-comments').jump_next() end, desc = '[todo] Next todo comment', },
   { '[t',         function() require('todo-comments').jump_prev() end, desc = '[todo] Previous todo comment', },
   { '<leader>xt', cmd('TodoTrouble'),                                  desc = '[todo] Todo (Trouble)' },
   { '<leader>xT', cmd('TodoTrouble keywords=TODO,FIX,FIXME'),          desc = '[todo] Todo/Fix/Fixme (Trouble)' },
   { '<leader>st', cmd('TodoTelescope'),                                desc = '[todo] Todo' },
   { '<leader>sT', cmd('TodoTelescope keywords=TODO,FIX,FIXME'),        desc = '[todo] Todo/Fix/Fixme' },
}

return M
