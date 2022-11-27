-- ref: https://github.com/ecosse3/nvim/blob/master/lua/lsp/servers/tailwindcss.lua

local M = {}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.colorProvider = { dynamicRegistration = false }
capabilities.textDocument.foldingRange = {
   dynamicRegistration = false,
   lineFoldingOnly = true,
}

-- Settings
local on_attach = function(client, bufnr)
   if client.server_capabilities.colorProvider then
      require('colorizer').attach_to_buffer(
         bufnr,
         { mode = 'background', css = true, names = false, tailwind = true }
      )
   end
end

local init_options = {
   userLanguages = {
      eelixir = 'html-eex',
      eruby = 'erb',
   },
}

local settings = {
   tailwindCSS = {
      classAttributes = { 'class', 'className', 'classList', 'ngClass' },
      lint = {
         cssConflict = 'warning',
         invalidApply = 'error',
         invalidConfigPath = 'error',
         invalidScreen = 'error',
         invalidTailwindDirective = 'error',
         invalidVariant = 'error',
         recommendedVariantOrder = 'warning',
      },
      experimental = {
         classRegex = {
            'tw`([^`]*)',
            'tw="([^"]*)',
            'tw={"([^"}]*)',
            'tw\\.\\w+`([^`]*)',
            'tw\\(.*?\\)`([^`]*)',
            { 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { 'classnames\\(([^)]*)\\)', "'([^']*)'" },
         },
      },
      validate = true,
   },
}

M.on_attach = on_attach
M.capabilities = capabilities
M.settings = settings
M.init_options = init_options

return M
