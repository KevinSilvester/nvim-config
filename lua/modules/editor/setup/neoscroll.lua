local m = require('core.mapper')
local M = {}

M.opts = {
   mappings = {
      nil, --[[ '<C-u>', ]]
      nil, --[[ '<C-d>', ]]
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
   },
}

M.config = function(_, opts)
   local neoscroll = require('neoscroll')

   local sc = function(lines, duration)
      return function()
         neoscroll.scroll(lines, { duration = duration, move_cursor = true })
      end
   end

   neoscroll.setup(opts)
   m.nmap({
      {
         '<C-u>',
         sc(-vim.wo.scroll, 100),
         m.opts(m.noremap, m.silent, '[neoscroll] Scroll up'),
      },
      {
         '<C-d>',
         sc(vim.wo.scroll, 100),
         m.opts(m.noremap, m.silent, '[neoscroll] Scroll down'),
      },
      {
         '(',
         sc(-1, 0),
         m.opts(m.noremap, m.silent, '[neoscroll] Scroll up one line'),
      },
      {
         ')',
         sc(1, 0),
         m.opts(m.noremap, m.silent, '[neoscroll] Scroll down one line'),
      },
   })
end

return M
