local M = {}

M.opts = {
   live_update = true,
   default = {
      find = {
         cmd = 'rg',
         options = { 'ignore-case' },
      },
      replace = {
         cmd = 'sed',
      },
   },
}

M.keys = {
   {
      '<leader>Ss',
      function()
         require('spectre').open_visual()
      end,
      desc = 'Search and Replace (Current Directory)',
   },
   {
      '<leader>Sw',
      function()
         require('spectre').open_visual({ select_word = true })
      end,
      desc = 'Search and Replace Current Word (Current Directory)',
   },
   {
      '<leader>Sf',
      function()
         require('spectre').open_file_search()
      end,
      desc = 'Search and Replace (Current File)',
   },
}

return M
