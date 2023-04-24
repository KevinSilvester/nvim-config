require('project_nvim').setup({
   -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
   detection_methods = { 'pattern' },

   -- patterns used to detect root dir, when **"pattern"** is in detection_methods
   patterns = { '.git', 'Makefile', 'package.json', 'Cargo.toml' },
})
