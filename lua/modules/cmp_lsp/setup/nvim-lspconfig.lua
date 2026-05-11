local m = require('core.mapper')
local M = {}

-- stylua: ignore
M.keys = {
   { '<leader>lc', require('utils.lsp').server_capabilities,                               desc = '[utils] Get Capabilities' },
   { '<leader>ld', vim.diagnostic.open_float,                                              desc = '[builtin] Line Diagnostics' },
   { '<leader>lf', function() vim.lsp.buf.format({ async = true, timeout_ms = 1000 }) end, desc = '[builtin] Format File',     mode = { 'n' } },
   {
      '<leader>lf',
      function()
         vim.lsp.buf.format({
            async = true,
            timeout_ms = 1000,
            range = {
               ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
               ['end'] = vim.api.nvim_buf_get_mark(0, '>')
            }
         })
      end,
      desc = '[builtin] Format File',
      mode = { 'v' }
   },
   { '<leader>li',  m.cmd('LspInfo'),                                                                desc = '[lspconfig] LSP Info' },
   { '<leader>lr',  vim.lsp.buf.rename,                                                            desc = '[builtin] Rename' },
   { '<leader>lar', vim.lsp.codelens.run,                                                          desc = '[builtin] Run CodeLens Action' },
   { '<leader>lt',  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = '[builtin] Toggle inlay hints' },
   { '[d',          function() vim.diagnostic.jump({ count = -1 }) end,                            desc = '[builtin] Goto Prev Diagnostics' },
   { ']d',          function() vim.diagnostic.jump({ count = 1 }) end,                             desc = '[builtin] Goto Next Diagnostics' },
   {
      '[e',
      function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
      desc = '[builtin] Goto Prev Error'
   },
   {
      ']e',
      function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
      desc = '[builtin] Goto Next Error'
   },
}

return M
