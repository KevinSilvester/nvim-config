local M = {}

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
         globals = { 'vim' },
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
