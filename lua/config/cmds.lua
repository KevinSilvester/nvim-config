local colours = require('utils.colours')

-- command to act as alias for custom inspect function
vim.api.nvim_create_user_command('Inspect', function(opts)
   log.debug('config.inspect', opts)
   vim.cmd("lua require('utils.fn').inspect(" .. opts.args .. ')')
end, {
   nargs = 1,
   complete = function(ArgLead, CmdLine, CursorPo)
      return { 'vim', 'require' }
   end,
})

-- command to get the hex colour values for Hl group
vim.api.nvim_create_user_command('InspectHl', function(opts)
   local hl = colours.get_highlight(opts.args)
   vim.cmd("lua require('utils.fn').inspect(" .. hl .. ')')
end, {
   nargs = 1,
   complete = function(ArgLead, CmdLine, CursorPo)
      return { 'highlight' }
   end,
})
