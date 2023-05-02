local M = {}

M.config = function()
   local null_ls = require('null-ls')

   null_ls.setup({
      debug = false,
      sources = {
         null_ls.builtins.formatting.prettier,
         null_ls.builtins.formatting.black.with({ extra_args = { '--fast' } }),
         -- null_ls.builtins.formatting.autopep8,
         -- null_ls.builtins.formatting.yapf,
         null_ls.builtins.formatting.stylua,
         null_ls.builtins.formatting.google_java_format,
         null_ls.builtins.formatting.blade_formatter,
         null_ls.builtins.formatting.sql_formatter,
         null_ls.builtins.formatting.clang_format,
         null_ls.builtins.formatting.cmake_format,
         null_ls.builtins.formatting.rustfmt,
         null_ls.builtins.formatting.taplo,
         null_ls.builtins.diagnostics.flake8,
         require('typescript.extensions.null-ls.code-actions'),
      },
   })
end

return M
