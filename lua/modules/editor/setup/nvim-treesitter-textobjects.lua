local M = {}

M.opts = {}

M.keys = {
   -- select
   {
      'af',
      function()
         require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end,
      mode = { 'o', 'x' },
      desc = '[ts-textobjects] select around function',
   },
   {
      'if',
      function()
         require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end,
      mode = { 'o', 'x' },
      desc = '[ts-textobjects] select inside function',
   },
   {
      'ac',
      function()
         require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end,
      mode = { 'o', 'x' },
      desc = '[ts-textobjects] select around class',
   },
   {
      'ic',
      function()
         require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end,
      mode = { 'o', 'x' },
      desc = '[ts-textobjects] select inside class',
   },
   {
      'as',
      function()
         require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
      end,
      mode = { 'o', 'x' },
      desc = '[ts-textobjects] select around scope',
   },

   -- go to next start
   {
      ']}',
      function()
         require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next function start',
   },
   {
      ']M',
      function()
         require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next class start',
   },

   -- go to next end
   {
      ']]',
      function()
         require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next function end',
   },
   {
      ']c',
      function()
         require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next class end',
   },
   {
      ']s',
      function()
         require('nvim-treesitter-textobjects.move').goto_next_end('@local.scope', 'locals')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next scope end',
   },

   -- go to previous start
   {
      '[[',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to previous function start',
   },
   {
      '[c',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to previous class start',
   },
   {
      '[s',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous_start('@local.scope', 'locals')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to previous scope start',
   },

   -- go to previous end
   {
      '[{',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to previous function end',
   },
   {
      '[M',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '',
   },

   -- go to (simple)
   {
      ']o',
      function()
         require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to next conditional',
   },
   {
      '[o',
      function()
         require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
      end,
      mode = { 'o', 'n', 'x' },
      desc = '[ts-textobjects] go to previous conditional',
   },
}

return M
