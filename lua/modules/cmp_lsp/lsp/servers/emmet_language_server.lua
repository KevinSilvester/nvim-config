local M = {}

M.filetypes = {
   'css',
   'eruby',
   'html',
   'javascript',
   'javascriptreact',
   'less',
   'sass',
   'scss',
   'pug',
   'typescriptreact',
   'rust',
   'vue',
}

M.init_options = {
   includedLanguages = {
      svelte = 'html',
      rust = 'html',
   },
}

M.root_dir = vim.fs.dirname(vim.fs.find({ '.emmet-root' }, { upward = true })[1])

return M
