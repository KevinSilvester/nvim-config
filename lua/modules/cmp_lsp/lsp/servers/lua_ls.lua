local M = {}

vim.cmd([[packadd neodev.nvim]])

require('neodev').setup({
   library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = true,
   },
   setup_jsonls = true,
   lspconfig = true,
})

M.settings = {
   Lua = {
      completion = {
         callSnippet = 'Replace',
      },
      runtime = {
         version = 'LuaJIT',
         special = {
            reload = 'require',
         },
      },
      diagnostics = {
         globals = { 'vim', 'packer_plugins' },
      },
      workspace = {
         library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
         },
      },
      telemetry = {
         enable = false,
      },
   },
}

return M
