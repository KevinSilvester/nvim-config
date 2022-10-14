require('tabout').setup({
   tabkey = '<A-l>',
   backwards_tabkey = '<A-h>',
   ignore_beginning = false,
   act_as_tab = true,
   enable_backward = true,
   completion = true,
   tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
   },
   exclude = {},
})
