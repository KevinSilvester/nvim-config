local cmd = require('core.mapper').cmd
local M = {}

M.opts = {
   size = 20,
   open_mapping = '<C-p>',
   hide_numbers = true,
   shade_terminals = true,
   shading_factor = 2,
   start_in_insert = true,
   persist_size = true,
   direction = 'float',
   close_on_exit = true,
   shell = vim.o.shell,
   float_opts = { border = 'curved' },
}

M.keys = {
   { '<C-p>', cmd('ToggleTerm direction=float'), desc = 'new terminal (float)' },
   { '<leader>tf', cmd('ToggleTerm direction=float'), desc = 'new terminal (float)' },
   { '<leader>th', cmd('ToggleTerm direction=horizontal size=10'), desc = 'new terminal (horizontal)' },
   { '<leader>tv', cmd('ToggleTerm direction=vertical size=80'), desc = 'new terminal (vertical)' },
}

return M
