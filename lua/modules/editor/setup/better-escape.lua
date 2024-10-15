local M = {}

M.opts = {
   default_mappings = true,
   timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
}

return M
