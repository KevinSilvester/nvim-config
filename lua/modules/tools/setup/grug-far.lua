local M = {}

M.opts = {
   engines = {
      ripgrep = {
         extraArgs = '--ignore-case',
      },
   },
   -- ref: https://github.com/MagicDuck/grug-far.nvim/blob/0e391cc375702299b8dac101ff5a7d418fb193b9/lua/grug-far/opts.lua#L168C3-L190C5
   keymaps = {
      replace = { n = '<localleader>r' },
      qflist = { n = '<localleader>q' },
      syncLocations = { n = '<localleader>s' },
      syncLine = { n = '<localleader>l' },
      close = { n = 'q' },
      historyOpen = { n = '<localleader>t' },
      historyAdd = { n = '<localleader>a' },
      refresh = { n = '<localleader>f' },
      openLocation = { n = '<localleader>o' },
      openNextLocation = { n = '<down>' },
      openPrevLocation = { n = '<up>' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<localleader>b' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '<localleader>p' },
      swapEngine = { n = '<localleader>e' },
      previewLocation = { n = '<localleader>i' },
      swapReplacementInterpreter = { n = '<localleader>x' },
      applyNext = { n = '<localleader>j' },
      applyPrev = { n = '<localleader>k' },
   },
}

M.keys = {
   {
      '<leader>Ss',
      function()
         require('grug-far').open()
      end,
      desc = '[grug-far] Search+Replace',
   },
   {
      '<leader>Sw',
      function()
         require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
      end,
      desc = '[grug-far] Search+Replace Word',
   },
   {
      '<leader>Sf',
      function()
         require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
      end,
      desc = '[grug-far] Search+Replace (Current File)',
   },
}

return M
