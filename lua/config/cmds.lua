local colours = require('utils.colours')

-- command to act as alias for custom inspect function
vim.api.nvim_create_user_command('Inspect', function(opts)
   local args = vim.split(opts.args, '|')
   local expr = args[1]
   local yank = args[2] == 'true' and 'true' or 'false'
   vim.cmd("lua require('utils.fn').inspect(" .. expr .. ',' .. yank .. ')')
end, {
   nargs = 1,
   complete = 'lua',
})

-- command to get the hex colour values for Hl group
vim.api.nvim_create_user_command('InspectHl', function(opts)
   local args = vim.split(opts.args, '|')
   local expr = args[1]
   local yank = args[2] == 'true' and 'true' or 'false'
   vim.cmd(
      "lua require('utils.fn').inspect(require('utils.colours').get_highlight(" .. expr .. ',' .. yank .. '))'
   )
end, {
   nargs = 1,
   complete = 'highlight',
})
