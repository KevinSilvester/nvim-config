-- ref: https://github.com/ecosse3/nvim/blob/master/lua/lsp/servers/tailwindcss.lua

local filetypes = require('tailwind-tools.filetypes')
local M = {}

M.capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
   textDocument = {
      colorProvider = { dynamicRegistration = false },
      foldingRange = {
         dynamicRegistration = false,
         lineFoldingOnly = true,
      },
   },
})

M.filetypes = filetypes.get_all()

M.init_options = { userLanguages = filetypes.get_server_map() }

M.settings = {
   includeLanguages = filetypes.get_server_map(),
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

M.root_dir = require('lspconfig.configs.tailwindcss').default_config.root_dir

return M
