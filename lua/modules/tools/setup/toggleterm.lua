local m = require('core.mapper')
local M = {}

M.opts = function()
   return {
      size = 30,
      -- open_mapping = '<C-_>',
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = { border = 'curved' },
   }
end

-- stylua: ignore
M.keys = {
   -- { '<C-_>',      m.cmd('ToggleTerm direction=float'),              desc = 'new terminal (float)' },
   { '<leader>tf', m.cmd('ToggleTerm direction=float'),              desc = 'new terminal (float)' },
   { '<leader>th', m.cmd('ToggleTerm direction=horizontal size=10'), desc = 'new terminal (horizontal)' },
   { '<leader>tv', m.cmd('ToggleTerm direction=vertical size=80'),   desc = 'new terminal (vertical)' },
}

return M
