local ufn = require('utils.fn')

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

-- set the tab options for specific work repos
vim.api.nvim_create_user_command('Work', function(opts)
   local augroup_name = 'config.cmds.work'

   if opts.args == 'on' then
      ufn.tab_opts(2, vim.api.nvim_get_current_buf())
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
         group = vim.api.nvim_create_augroup(augroup_name, { clear = true }),
         pattern = '*.{js,ts,md,css,json,mjs,cjs}',
         desc = 'Set tabstop, shiftwidth to 2 for js,md,ts files',
         callback = function(args)
            ufn.tab_opts(2, args.buf)
         end,
      })
   elseif opts.args == 'off' then
      ufn.tab_opts(3, vim.api.nvim_get_current_buf())
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
         group = vim.api.nvim_create_augroup(augroup_name, { clear = true }),
         pattern = '*.{js,ts,md,css,json,mjs,cjs}',
         desc = 'Revert tabstop, shiftwidth to 3 for js,md,ts files',
         callback = function(args)
            ufn.tab_opts(3, args.buf)
         end,
      })
   else
      log:warn('config.cmds.work', 'Invalid Subcommand!')
   end
end, {
   nargs = 1,
   complete = function(_, line)
      local subcommands = { 'on', 'off' }
      local args = vim.split(line, '%s+')
      if #args ~= 2 then
         return {}
      end

      return vim.tbl_filter(function(subcommand)
         return vim.startswith(subcommand, args[2])
      end, subcommands)
   end,
})

vim.api.nvim_create_user_command('Tab', function(opts)
   local val = string.gsub(opts.args, ' ', '')
   if val:match('^%d+$') then
      ---@diagnostic disable-next-line: param-type-mismatch
      ufn.tab_opts(tonumber(val))
   else
      log:error('config.cmds.tab', 'Invalid value!')
   end
end, {
   nargs = 1,
   complete = function(_, line)
      local args = vim.split(line, '%s+')
      if #args ~= 2 then
         return {}
      end

      return { tostring(vim.o.tabstop) }
   end,
})

vim.api.nvim_create_user_command('Ibr', function()
   vim.cmd('IBLDisable')
   vim.cmd('IBLEnable')
end, { nargs = 0 })
