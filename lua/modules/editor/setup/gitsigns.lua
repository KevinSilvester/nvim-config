local m = require('core.mapper')
local M = {}

M.opts = {
   signs = {
      add = { text = '▍' },
      change = { text = '▍' },
      delete = { text = '󰐊' },
      topdelete = { text = '󰐊' },
      changedelete = { text = '▍' },
   },
   signs_staged = {
      add = { text = '▍' },
      change = { text = '▍' },
      delete = { text = '󰐊' },
      topdelete = { text = '󰐊' },
      changedelete = { text = '▍' },
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
   { ']h',          m.cmd('Gitsigns next_hunk'),                 desc = '[gitsigns] Next Hunk' },
   { '[h',          m.cmd('Gitsigns prev_hunk'),                 desc = '[gitsigns] Prev Hunk' },
   { '<leader>gB',  m.cmd('Gitsigns blame_line'),                desc = '[gitsigns] Blame Line' },
   { '<leader>ghp', m.cmd('Gitsigns preview_hunk_inline'),       desc = '[gitsigns] Preview Hunk' },
   { '<leader>ghs', m.cmd('Gitsigns select_hunk'),               desc = '[gitsigns] Select Hunk' },
   { '<leader>grb', m.cmd('Gitsigns reset_buffer'),              desc = '[gitsigns] Reset Buffer' },
   { '<leader>grB', m.cmd('Gitsigns reset_base'),                desc = '[gitsigns] Reset Base' },
   { '<leader>grh', m.cmd('Gitsigns reset_hunk'),                desc = '[gitsigns] Reset Hunk' },
   { '<leader>gR',  m.cmd('Gitsigns refresh'),                   desc = '[gitsigns] Refresh' },
   { '<leader>gsb', m.cmd('Gitsigns stage_buffer'),              desc = '[gitsigns] Stage Buffer' },
   { '<leader>gsh', m.cmd('Gitsigns stage_hunk'),                desc = '[gitsigns] Stage Hunk' },
   { '<leader>gsu', m.cmd('Gitsigns undo_stage_hunk'),           desc = '[gitsigns] Undo Stage Hunk' },
   { '<leader>gtb', m.cmd('Gitsigns toggle_current_line_blame'), desc = '[gitsigns] Toggle Line Blame' },
   { '<leader>gtd', m.cmd('Gitsigns toggle_deleted'),            desc = '[gitsigns] Toggle Deleted' },
   { '<leader>gth', m.cmd('Gitsigns toggle_linehl'),             desc = '[gitsigns] Toggle Highlight Line' },
   { '<leader>gts', m.cmd('Gitsigns toggle_signs'),              desc = '[gitsigns] Toggle Signs' },
}

return M
