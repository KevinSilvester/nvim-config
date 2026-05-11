local M = {}

-- local function filterReactDTS(value)
--    -- Depending on typescript version either uri or targetUri is returned
--    if value.uri then
--       return string.match(value.uri, '%.d.ts') == nil
--    elseif value.targetUri then
--       return string.match(value.targetUri, '%.d.ts') == nil
--    end
-- end

M.config = function()
   require('typescript-tools').setup({
      -- disabling formatting capabilities of tsserver to not conflict with biome or null-ls
      -- ref: https://github.com/pmizio/typescript-tools.nvim/issues/288#issuecomment-2262062771
      on_attach = function(client)
         client.server_capabilities.documentFormattingProvider = false
         client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
         --- spawn additional tsserver instance to calculate diagnostics on it
         separate_diagnostic_server = true,

         -- determine when the client asks the server about diagnostic
         ---@type "change"|"insert_leave"
         publish_diagnostic_on = 'insert_leave',

         -- specify commands exposed as code_actions
         ---@type ("fix_all"|"add_missing_imports"|"remove_unused"|"remove_unused_imports"|"organize_imports")[]|"all"
         expose_as_code_action = 'all',

         -- specify a custom path to `tsserver.js` file, if this is nil or file under path
         -- not exists then standard path resolution strategy is applied
         ---@type string|nil
         tsserver_path = nil,

         -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
         -- memory limit in megabytes or "auto"(basically no limit)
         tsserver_max_memory = 'auto',

         -- described below
         tsserver_format_options = {},

         tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
         },

         -- locale of all tsserver messages, supported locales you can find here:
         -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
         tsserver_locale = 'en',

         -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
         complete_function_calls = false,

         include_completions_with_insert_text = true,

         -- CodeLens
         -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
         ---@type 'off'|'all'|'implementations_only'|'references_only'
         code_lens = 'all',

         -- by default code lenses are displayed on all referencable values and for some of you it can
         -- be too much this option reduce count of them by removing member references from lenses
         disable_member_code_lens = true,

         -- JSXCloseTag
         -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
         -- that maybe have a conflict if enable this feature. )
         jsx_close_tag = {
            enable = false,
            filetypes = { 'javascriptreact', 'typescriptreact' },
         },
      },
   })
end

return M
