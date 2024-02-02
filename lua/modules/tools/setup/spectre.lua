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
      desc = '[spectre] Search+Replace (Current Directory)',
   },
   {
      '<leader>Sw',
      function()
         require('spectre').open_visual({ select_word = true })
      end,
      desc = '[spectre] Search+Replace Word (Current Directory)',
   },
   {
      '<leader>Sf',
      function()
         require('spectre').open_file_search()
      end,
      desc = '[spectre] Search+Replace (Current File)',
   },
}

return M
