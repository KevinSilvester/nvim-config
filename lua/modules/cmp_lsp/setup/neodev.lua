local M = {}

M.opts = {
   experimental = { pathStrict = true },
   library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = true,
   },
   setup_jsonls = true,
   lspconfig = true,
}

return M
