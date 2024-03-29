require('dapui').setup({
   icons = { expanded = '▾', collapsed = '▸' },
   mappings = {
      -- Use a table to apply multiple mappings
      expand = { '<CR>', '<2-LeftMouse>' },
      open = 'o',
      remove = 'd',
      edit = 'e',
      repl = 'r',
   },
   layouts = {
      {
         elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
               id = 'scopes',
               size = 0.25, -- Can be float or integer > 1
            },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
         },
         size = 40,
         position = 'left',
      },
      { elements = { 'repl' }, size = 10, position = 'bottom' },
   },
   -- Requires Nvim version >= 0.8
   controls = {
      enabled = true,
      -- Display controls in this session
      element = 'repl',
      icons = {
         pause = '',
         play = '',
         step_into = '',
         step_over = '',
         step_out = '',
         step_back = '',
         run_last = '↻',
         terminate = 'ﱢ',
      },
   },
   floating = {
      max_height = nil,
      max_width = nil,
      mappings = { close = { 'q', '<Esc>' } },
   },
   windows = { indent = 1 },
})
