local M = {}

M.config = function()
   require('copilot_cmp').setup({
      method = 'getCompletionsCycling',
      force_autofmt = false,
      fix_indent = true,
      -- should not be necessary due to cmp changes
      -- clear_after_cursor = true,
      formatters = {
         label = require('copilot_cmp.format').format_label_text,
         insert_text = require('copilot_cmp.format').format_insert_text,
         preview = require('copilot_cmp.format').deindent,
      },
   })
end

return M
