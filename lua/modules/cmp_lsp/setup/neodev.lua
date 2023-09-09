local M = {}

M.opts = {
   library = {
      enabled = false,
      runtime = true,
      types = true,
      plugins = true,
   },
   setup_jsonls = false,
   lspconfig = true,
   pathStrict = true
}

return M
