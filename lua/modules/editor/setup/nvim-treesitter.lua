local ufs = require('utils.fs')

local M = {}

M.opts = {
   -- ensure_installed = DEFAULT_TREESITTER_PARSERS,
   auto_install = false,
   indent = {
      enable = true,
      disable = { 'python', 'css', 'yaml' },
   },
   highlight = { enable = true },
   auto_pairs = { enable = true },
   autotag = { enable = false },
   context = {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
      zindex = 20,
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
      swap = { enable = false },
   },
   rainbow = {
      enable = false,
      extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
      max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
   },
   context_commentstring = { enable = true, enable_autocmd = true },
   matchup = { enable = true },
   parser_install_dir = ufs.path_join(PATH.data, 'treesitter'),
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = '<C-space>',
         node_incremental = '<C-space>',
         scope_incremental = '<nop>',
         node_decremental = '<bs>',
      },
   },
}

M.config = function(_, opts)
   -- no need to load on headless mode
   if #vim.api.nvim_list_uis() == 0 then
      return
   end

   require('nvim-treesitter.install').prefer_git = true
   require('nvim-treesitter.install').compilers = HOST.is_win and { 'clang' } or { 'clang', 'gcc', 'zig' }
   require('nvim-treesitter.configs').setup(opts)

   -- handle deprecated API, https://github.com/windwp/nvim-autopairs/pull/324
   require('nvim-treesitter.ts_utils').is_in_node_range = vim.treesitter.is_in_node_range
   require('nvim-treesitter.ts_utils').get_node_range = vim.treesitter.get_node_range

   vim.api.nvim_create_user_command('TSInstall', function(o)
      local bang = o.bang and '!' or ''
      require('nvim-treesitter.install').commands.TSInstall['run' .. bang](o.args)
   end, { nargs = '+', bang = true, complete = 'custom,nvim_treesitter#installable_parsers' })

   vim.api.nvim_command('set foldmethod=expr')
   vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')

   -- vim.cmd([[:e]])
end

return M
