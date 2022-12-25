require('gitsigns').setup({
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
})
