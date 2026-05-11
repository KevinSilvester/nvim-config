return {
   {
      'GitMarkedDan/you-are-an-idiot.nvim',
      cmd = 'ToggleIdiot',
      config = function()
         vim.api.nvim_create_user_command('ToggleIdiot', require('you-are-an-idiot').toggle, { nargs = 0 })
      end,
      enabled = false,
   },
}
