local i = require('modules.ui.icons')
local ufn = require('utils.fn')
local M = {}

---@type dropbar_opts_t
M.opts = {
   icons = {
      -- enable = true,
      kinds = {
         symbols = ufn.pad_str(i.kind),
      },
      ui = {
         bar = {
            separator = ' ',
            extends = '…',
         },
         menu = {
            separator = ' ',
            indicator = ' ',
         },
      },
   },
}

return M
