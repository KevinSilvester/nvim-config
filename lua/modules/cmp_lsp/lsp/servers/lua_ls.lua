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
         unusedLocalExclude = { '_*' },
      },
      workspace = {
         library = {
            'lua',
            '${3rd}/luv/library',
         },
      },
      telemetry = {
         enable = false,
      },
   },
}

return M
