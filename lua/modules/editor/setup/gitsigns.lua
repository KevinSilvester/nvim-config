local cmd = require('core.mapper').cmd
local M = {}

M.opts = {
   signs = {
      add = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change = {
         hl = 'GitSignsChange',
         text = '▎',
         numhl = 'GitSignsChangeNr',
         linehl = 'GitSignsChangeLn',
      },
      delete = {
         hl = 'GitSignsDelete',
         text = '契',
         numhl = 'GitSignsDeleteNr',
         linehl = 'GitSignsDeleteLn',
      },
      topdelete = {
         hl = 'GitSignsDelete',
         text = '契',
         numhl = 'GitSignsDeleteNr',
         linehl = 'GitSignsDeleteLn',
      },
      changedelete = {
         hl = 'GitSignsChange',
         text = '▎',
         numhl = 'GitSignsChangeNr',
         linehl = 'GitSignsChangeLn',
      },
   },
   preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
   },
}

-- stylua: ignore
M.keys = {
   { ']h',          cmd('Gitsigns next_hunk'),                 desc = 'Next Hunk' },
   { '[h',          cmd('Gitsigns prev_hunk'),                 desc = 'Prev Hunk' },
   { '<leader>gl',  cmd('Gitsigns blame_line'),                desc = 'Blame Line' },
   { '<leader>ghp', cmd('Gitsigns preview_hunk'),              desc = 'Preview Hunk' },
   { '<leader>ghP', cmd('Gitsigns preview_hunk_inline'),       desc = 'Preview Hunk Inline' },
   { '<leader>ghs', cmd('Gitsigns select_hunk'),               desc = 'Select Hunk' },
   { '<leader>grb', cmd('Gitsigns reset_buffer'),              desc = 'Reset Buffer' },
   { '<leader>grB', cmd('Gitsigns reset_base'),                desc = 'Reset Base' },
   { '<leader>grh', cmd('Gitsigns reset_hunk'),                desc = 'Reset Hunk' },
   { '<leader>gR',  cmd('Gitsigns refresh'),                   desc = 'Refresh' },
   { '<leader>gsb', cmd('Gitsigns stage_buffer'),              desc = 'Stage Buffer' },
   { '<leader>gsh', cmd('Gitsigns stage_hunk'),                desc = 'Stage Hunk' },
   { '<leader>gsu', cmd('Gitsigns undo_stage_hunk'),           desc = 'Undo Stage Hunk' },
   { '<leader>gtb', cmd('Gitsigns toggle_current_line_blame'), desc = 'Toggle Line Blame' },
   { '<leader>gtd', cmd('Gitsigns toggle_deleted'),            desc = 'Toggle Deleted' },
   { '<leader>gtl', cmd('Gitsigns toggle_linehl'),             desc = 'Toggle Highlight Line' },
   { '<leader>gts', cmd('Gitsigns toggle_signs'),              desc = 'Toggle Signs' },
   { '<leader>gtu', cmd('Gitsigns toggle_linehl'),             desc = 'Toggle Line Highlight' },
}

return M
