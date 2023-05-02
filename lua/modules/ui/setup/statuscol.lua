local M = {}

M.config = function()
   local builtin = require('statuscol.builtin')
   require('statuscol').setup({
      -- foldunc = 'builtin',
      -- setopt = true,
      relculright = true,
      segments = {
         { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
         { text = { '%s' }, click = 'v:lua.ScSa' },
         { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
      },
   })
end

return M
