local M = {}

M.on_attach = function(client, bufnr)
   client.server_capabilities.documentFormattingProvider = false
   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

M.settings = {
   codeAction = {
      disableRuleComment = {
         enable = true,
         location = 'separateLine',
      },
      showDocumentation = {
         enable = true,
      },
   },
   codeActionOnSave = {
      enable = false,
      mode = 'all',
   },
   format = false,
   nodePath = '',
   onIgnoredFiles = 'off',
   packageManager = 'pnpm',
   quiet = false,
   rulesCustomizations = {},
   run = 'onType',
   useESLintClass = false,
   validate = 'on',
   workingDirectory = {
      mode = 'location',
   },
}

return M
