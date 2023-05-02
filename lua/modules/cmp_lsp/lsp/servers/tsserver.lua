-- ref: https://github.com/ecosse3/nvim/blob/master/lua/lsp/servers/tsserver.lua

local M = {}

local capabilities_extension = {
   textDocument = {
      foldingRange = {
         dynamicRegistration = false,
         lineFoldingOnly = true,
      },
   },
}

M.capabilities =
   vim.tbl_deep_extend('force', require('modules.cmp_lsp.lsp.setup').capabilites, capabilities_extension)

local function filter(arr, fn)
   if type(arr) ~= 'table' then
      return arr
   end

   local filtered = {}
   for k, v in pairs(arr) do
      if fn(v, k, arr) then
         table.insert(filtered, v)
      end
   end

   return filtered
end

local function filterReactDTS(value)
   -- Depending on typescript version either uri or targetUri is returned
   if value.uri then
      return string.match(value.uri, '%.d.ts') == nil
   elseif value.targetUri then
      return string.match(value.targetUri, '%.d.ts') == nil
   end
end

M.handlers = {
   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
   ['textDocument/definition'] = function(err, result, method, ...)
      if vim.tbl_islist(result) and #result > 1 then
         local filtered_result = filter(result, filterReactDTS)
         return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
   end,
}

M.settings = {
   typescript = {
      inlayHints = {
         includeInlayParameterNameHints = 'all',
         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
         includeInlayFunctionParameterTypeHints = true,
         includeInlayVariableTypeHints = false,
         includeInlayPropertyDeclarationTypeHints = true,
         includeInlayFunctionLikeReturnTypeHints = false,
         includeInlayEnumMemberValueHints = true,
      },
   },
   javascript = {
      inlayHints = {
         includeInlayParameterNameHints = 'all',
         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
         includeInlayFunctionParameterTypeHints = true,
         includeInlayVariableTypeHints = false,
         includeInlayPropertyDeclarationTypeHints = true,
         includeInlayFunctionLikeReturnTypeHints = false,
         includeInlayEnumMemberValueHints = true,
      },
   },
}

return M
