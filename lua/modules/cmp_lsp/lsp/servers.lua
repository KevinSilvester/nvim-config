local M = {}

M.default = {
   capabalities = require('modules.cmp_lsp.lsp.setup').capabilites,
   on_attach = require('modules.cmp_lsp.lsp.setup').on_attach,
}

M.custom = {
   cssls = {
      capabalities = M.default.capabalities,
      on_attach = require('modules.cmp_lsp.lsp.servers.cssls').on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.cssls').settings,
   },
   emmet_ls = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      cmd = require('modules.cmp_lsp.lsp.servers.emmet_ls').cmd,
      filetypes = require('modules.cmp_lsp.lsp.servers.emmet_ls').filetypes,
   },
   eslint = {
      capabilities = M.default.capabilities,
      on_attach = require('modules.cmp_lsp.lsp.servers.eslint').on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.eslint').settings,
   },
   jsonls = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.jsonls').settings,
      setup = require('modules.cmp_lsp.lsp.servers.jsonls').setup,
   },
   powershell_es = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      cmd = require('modules.cmp_lsp.lsp.servers.powershell_es').cmd,
      bundle_path = require('modules.cmp_lsp.lsp.servers.powershell_es').bundle_path,
   },
   pyright = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.pyright').settings,
   },
   lua_ls = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.lua_ls').settings,
   },
   tailwindcss = {
      capabilities = require('modules.cmp_lsp.lsp.servers.tailwindcss').capabilities,
      init_options = require('modules.cmp_lsp.lsp.servers.tailwindcss').init_options,
      on_attach = require('modules.cmp_lsp.lsp.servers.tailwindcss').on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.tailwindcss').settings,
   },
   vuels = {
      filetypes = require('modules.cmp_lsp.lsp.servers.vuels').filetypes,
      on_attach = M.default.on_attach,
      init_options = require('modules.cmp_lsp.lsp.servers.vuels').init_options,
   },
   yamlls = {
      capabilities = M.default.capabilities,
      on_attach = M.default.on_attach,
      settings = require('modules.cmp_lsp.lsp.servers.yamlls').settings,
   },
}

return M
