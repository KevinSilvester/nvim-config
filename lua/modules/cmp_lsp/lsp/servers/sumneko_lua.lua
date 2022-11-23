local M = {}
M.settings = {
   Lua = {
      completion = {
         callSnippet = 'Replace',
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
