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

   require('lsp-inlayhints').on_attach(client, bufnr, false)
   if client.server_capabilities['documentSymbolProvider'] then
      require('nvim-navic').attach(client, bufnr)
   end
   vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

   client.server_capabilities.document_formatting = false
   client.server_capabilities.documentFormattingProvider = false
   client.server_capabilities.documentRangeFormattingProvider = false
end

return M
