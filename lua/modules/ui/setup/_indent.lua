local M = {}

M.opts = {
   enabled = true,
   debounce = 200,
   indent = {
      char = '▏',
      tab_char = nil,
      highlight = 'IblIndent',
      smart_indent_cap = true,
      priority = 1,
   },
   whitespace = {
      highlight = 'IblWhitespace',
      remove_blankline_trail = true,
   },
   scope = {
      enabled = true,
      char = '▏',
      show_start = true,
      show_end = true,
      show_exact_scope = true,
      injected_languages = true,
      highlight = 'IblScope',
      priority = 1024,
      include = {
         node_type = { lua = { 'return_statement', 'table_constructor' } },
      },
      exclude = {
         language = {},
         node_type = {
            ['*'] = { 'source_file', 'program' },
            lua = { 'chunk' },
            python = { 'module' },
         },
      },
   },
   exclude = {
      filetypes = {
         'lspinfo',
         'checkhealth',
         'help',
         'man',
         'gitcommit',
         'TelescopePrompt',
         'TelescopeResults',
         'alpha',
         'Trouble',
         'lazy',
         'dashboard',
      },
      buftypes = {
         'terminal',
         'nofile',
         'quickfix',
         'prompt',
      },
   },
}

return M
