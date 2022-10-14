vim.api.nvim_command('set foldmethod=expr')
vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')

require('nvim-treesitter.configs').setup({
   ensure_installed = 'all',
   ignore_install = { 'phpdoc' },
   highlight = {
      enable = true,
   },
   indent = {
      enable = true,
      disable = { 'python', 'css' },
   },
   auto_pairs = {
      enable = true,
   },
   textobjects = {
      select = {
         enable = true,
         keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
         },
      },
      move = {
         enable = true,
         set_jumps = true, -- whether to set jumps in the jumplist
         goto_next_start = {
            [']['] = '@function.outer',
            [']m'] = '@class.outer',
         },
         goto_next_end = {
            [']]'] = '@function.outer',
            [']M'] = '@class.outer',
         },
         goto_previous_start = {
            ['[['] = '@function.outer',
            ['[m'] = '@class.outer',
         },
         goto_previous_end = {
            ['[]'] = '@function.outer',
            ['[M'] = '@class.outer',
         },
      },
   },
   context_commentstring = { enable = true, enable_autocmd = false },
   matchup = { enable = true },
   parser_install_dir = vim.fn.stdpath('data') .. '/treesitter',
})

require('nvim-treesitter.install').prefer_git = true
