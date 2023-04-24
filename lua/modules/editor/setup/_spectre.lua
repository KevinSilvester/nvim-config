require('spectre').setup({
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
})
