local ufs = require('utils.fs')
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
            [ufs.path_join(vim.fn.expand('$VIMRUNTIME'), 'lua')] = true,
            [ufs.path_join(PATH.config, 'lua')] = true,
            '${3rd}/luv/library',
         },
      },
      telemetry = {
         enable = false,
      },
   },
}

return M
