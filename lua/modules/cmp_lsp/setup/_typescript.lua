local lsp = vim.lsp
local M = {}

local function filterReactDTS(value)
   -- Depending on typescript version either uri or targetUri is returned
   if value.uri then
      return string.match(value.uri, '%.d.ts') == nil
   elseif value.targetUri then
      return string.match(value.targetUri, '%.d.ts') == nil
   end
end

local inlayHints = {
   includeInlayParameterNameHints = 'all',
   includeInlayParameterNameHintsWhenArgumentMatchesName = false,
   includeInlayFunctionParameterTypeHints = true,
   includeInlayVariableTypeHints = false,
   includeInlayPropertyDeclarationTypeHints = true,
   includeInlayFunctionLikeReturnTypeHints = false,
   includeInlayEnumMemberValueHints = true,
}

local capabilities_extension = {
   textDocument = {
      foldingRange = {
         dynamicRegistration = false,
         lineFoldingOnly = true,
      },
   },
}

M.config = function(_, _)
   require('typescript').setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      -- server = vim.tbl_deep_extend('force', default_opts, specific_opts),
      -- tsserver opts
      server = {
         -- tsserver-handlers
         handlers = {
            ['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'rounded' }),
            ['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = 'rounded' }),
            ['textDocument/definition'] = function(err, result, method, ...)
               if vim.tbl_islist(result) and #result > 1 then
                  local filtered_result = vim.tbl_filter(filterReactDTS, result)
                  return lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
               end

               lsp.handlers['textDocument/definition'](err, result, method, ...)
            end,
         },
         -- tsserver-settings
         settings = {
            typescript = { inlayHints = inlayHints },
            javascript = { inlayHints = inlayHints },
         },
         -- tsserver-capabilities
         capabilities = vim.tbl_deep_extend(
            'force',
            require('modules.cmp_lsp.lsp.setup').capabilities,
            capabilities_extension
         ),
         -- tsserver-on_attach
         on_attach = require('modules.cmp_lsp.lsp.setup').on_attach,
      },
   })
end

return M
