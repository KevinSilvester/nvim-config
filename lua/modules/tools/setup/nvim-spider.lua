local M = {}

M.keys = {
   { -- example for lazy-loading on keystroke
      'e',
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { 'n', 'o', 'x' },
   },
   { -- example using an explicit function
      'w',
      function()
         require('spider').motion('w', {
            customPatterns = {
               patterns = { ('%x'):rep(6) .. '+' },
               overrideDefault = true,
            },
         })
      end,
      mode = { 'n', 'o', 'x' },
   },
}

return M
