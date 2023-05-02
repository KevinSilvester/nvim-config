-- ref: https://github.com/ecosse3/nvim/blob/master/lua/lsp/servers/tailwindcss.lua

local M = {}

local capabilities_extension = {
   textDocument = {
      colorProvider = { dynamicRegistration = false },
      foldingRange = {
         dynamicRegistration = false,
         lineFoldingOnly = true,
      },
   },
}

M.capabilities =
   vim.tbl_deep_extend('force', require('cmp_nvim_lsp').default_capabilities(), capabilities_extension)

-- Settings
M.on_attach = function(client, bufnr)
   -- require('colorizer').attach_to_buffer(
   --    bufnr,
   --    { mode = 'background', css = true, names = false, tailwind = true }
   -- )
end

M.init_options = {
   userLanguages = {
      eelixir = 'html-eex',
      eruby = 'erb',
   },
}

M.settings = {
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

return M
