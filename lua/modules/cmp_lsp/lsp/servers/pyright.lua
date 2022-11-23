local M = {}

M.settings = {
   python = {
      analysis = {
         autoSearchPaths = true,
         useLibraryCodeForTypes = true,
         typeCheckingMode = 'basic',
         diagnosticMode = 'workspace',
         inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
         },
      },
   },
}

return M
