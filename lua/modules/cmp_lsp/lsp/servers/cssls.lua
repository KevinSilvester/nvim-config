local M = {}

M.settings = {
   css = {
      lint = {
         unknownAtRules = 'ignore',
      },
   },
   scss = {
      lint = {
         unknownAtRules = 'ignore',
      },
   },
}

M.on_attach = function(client, bufnr)
   require('modules.cmp_lsp.lsp.setup').set_lsp_keymaps(bufnr)
   require('modules.cmp_lsp.lsp.setup').attach_navic(client, bufnr)
   client.server_capabilities.documentFormattingProvider = false
   client.server_capabilities.documentRangeFormattingProvider = false
end

return M
