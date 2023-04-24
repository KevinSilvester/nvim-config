local M = {}

M.opts = {
   char = '▏',
   show_trailing_blankline_indent = false,
   show_first_indent_level = true,
   use_treesitter = package.loaded['nvim-treesitter'],
   show_current_context = true,
   buftype_exclude = { 'terminal', 'nofile' },
   filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy' },
}

return M
