local M = {}

M.opts = {
   default_mappings = false,
   timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
   mappings = {
      i = { j = { k = '<Esc>' } },
      s = { j = { k = '<Esc>' } },
      t = { j = { k = '<C-\\><C-n>' } },
   },
}

return M
