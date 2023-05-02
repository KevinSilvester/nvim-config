local cmd = require('core.mapper').cmd
local inspect = require('utils.fn').inspect
local M = {}

M.config = function(_, _)
   local map = require('mini.map')
   local diagnostic_integration = map.gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn = 'DiagnosticFloatingWarn',
      info = 'DiagnosticFloatingInfo',
      hint = 'DiagnosticFloatingHint',
   })

   map.setup({
      -- Highlight integrations (none by default)
      integrations = {
         map.gen_integration.builtin_search(),
         map.gen_integration.gitsigns(),
         diagnostic_integration,
      },
      -- Symbols used to display data
      symbols = {
         -- Encode symbols. See `:h MiniMap.config` for specification and
         -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
         -- Default: solid blocks with 3x2 resolution.
         encode = map.gen_encode_symbols.dot('4x2'),
         -- Scrollbar parts for view and line. Use empty string to disable any.
         scroll_line = '█',
         scroll_view = '┃',
      },
      -- Window options
      window = {
         focusable = true, -- Whether window is focusable in normal way (with `wincmd` or mouse)
         side = 'right', -- Side to stick ('left' or 'right')
         show_integration_count = true, -- Whether to show count of multiple integration highlights
         width = 20, -- Total width
         winblend = 25, -- Value of 'winblend' option
      },
   })
end

-- stylua: ignore
M.keys = {
   { '<leader>mc', function() require('mini.map').close() end,          desc = 'Open mini map' },
   { '<leader>mC', function() inspect(require('mini.map').current) end, desc = 'Mini map current state' },
   { '<leader>mo', function() require('mini.map').open() end,           desc = 'Close mini map' },
   { '<leader>mt', function() require('mini.map').toggle() end,         desc = 'Toggle mini map' },
   { '<leader>mT', function() require('mini.map').toggle_focus() end,   desc = 'Toggle Focus mini map' },
   { '<leader>mr', function() require('mini.map').refresh() end,        desc = 'Refresh mini map' },
}

return M
