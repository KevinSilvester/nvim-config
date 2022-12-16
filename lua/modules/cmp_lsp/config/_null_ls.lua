local null_ls = require('null-ls')

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
   debug = false,
   sources = {
      formatting.prettier.with({
         extra_filetypes = { 'toml' },
         extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' },
      }),
      -- formatting.black.with({ extra_args = { '--fast' } }),
      formatting.autopep8,
      -- formatting.yapf,
      formatting.stylua,
      formatting.google_java_format,
      formatting.blade_formatter,
      formatting.sql_formatter,
      formatting.clang_format,
      formatting.cmake_format,
      formatting.rustfmt,
      formatting.taplo,
      diagnostics.flake8,
      require('typescript.extensions.null-ls.code-actions'),
   },
})
