local cmd = require('core.mapper').cmd
local M = {}

M.opts = {
   signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '󰐊' },
      topdelete = { text = '󰐊' },
      changedelete = { text = '▎' },
   },
   signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '󰐊' },
      topdelete = { text = '󰐊' },
      changedelete = { text = '▎' },
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
   { ']h',          cmd('Gitsigns next_hunk'),                 desc = '[gitsigns] Next Hunk' },
   { '[h',          cmd('Gitsigns prev_hunk'),                 desc = '[gitsigns] Prev Hunk' },
   { '<leader>gl',  cmd('Gitsigns blame_line'),                desc = '[gitsigns] Blame Line' },
   { '<leader>ghp', cmd('Gitsigns preview_hunk'),              desc = '[gitsigns] Preview Hunk' },
   { '<leader>ghP', cmd('Gitsigns preview_hunk_inline'),       desc = '[gitsigns] Preview Hunk Inline' },
   { '<leader>ghs', cmd('Gitsigns select_hunk'),               desc = '[gitsigns] Select Hunk' },
   { '<leader>grb', cmd('Gitsigns reset_buffer'),              desc = '[gitsigns] Reset Buffer' },
   { '<leader>grB', cmd('Gitsigns reset_base'),                desc = '[gitsigns] Reset Base' },
   { '<leader>grh', cmd('Gitsigns reset_hunk'),                desc = '[gitsigns] Reset Hunk' },
   { '<leader>gR',  cmd('Gitsigns refresh'),                   desc = '[gitsigns] Refresh' },
   { '<leader>gsb', cmd('Gitsigns stage_buffer'),              desc = '[gitsigns] Stage Buffer' },
   { '<leader>gsh', cmd('Gitsigns stage_hunk'),                desc = '[gitsigns] Stage Hunk' },
   { '<leader>gsu', cmd('Gitsigns undo_stage_hunk'),           desc = '[gitsigns] Undo Stage Hunk' },
   { '<leader>gtb', cmd('Gitsigns toggle_current_line_blame'), desc = '[gitsigns] Toggle Line Blame' },
   { '<leader>gtd', cmd('Gitsigns toggle_deleted'),            desc = '[gitsigns] Toggle Deleted' },
   { '<leader>gth', cmd('Gitsigns toggle_linehl'),             desc = '[gitsigns] Toggle Highlight Line' },
   { '<leader>gts', cmd('Gitsigns toggle_signs'),              desc = '[gitsigns] Toggle Signs' },
}

return M
