local M = {}

M.keys = {
   { 'mx', desc = 'Set mark' },
   { 'm,', desc = 'Set the next mark' },
   { 'm;', desc = 'Toggle next available mark at the current line' },
   { 'dmx', desc = 'Delete mark' },
   { 'dm-', desc = 'Delete all marks on the current line' },
   { 'dm<space>', desc = 'Delete all marks in the current buffer' },
   { 'm]', desc = 'Move to next mark' },
   { 'm[', desc = 'Move to previous mark' },
   {
      'm:',
      desc = 'Preview mark',
   },
}

return M
