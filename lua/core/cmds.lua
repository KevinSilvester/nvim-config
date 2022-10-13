local utils = require("core.utils")

-- command to act as alias for custom inspect function
vim.api.nvim_create_user_command("Inspect", function(opts)
   vim.cmd("lua require('core.utils').inspect(" .. opts.args .. ")")
   -- utils.inspect(opts.args)
end, {
   nargs = 1,
   complete = function(ArgLead, CmdLine, CursorPo)
      return { "vim", "require" }
   end,
})

-- command to get the hex colour values for Hl group
vim.api.nvim_create_user_command("InspectHl", function(opts)
   local hl = utils.colors.get_highlight(opts.args)
   vim.cmd("lua require('core.utils').inspect(" .. hl .. ")")
end, {
   nargs = 1,
   complete = function(ArgLead, CmdLine, CursorPo)
      return { "highlight" }
   end,
})

