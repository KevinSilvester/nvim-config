local notify = require('notify')

local opts = {
   ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
   stages = 'slide',

   ---@usage Function called when a new window is opened, use for changing win settings/config
   on_open = nil,

   ---@usage Function called when a window is closed
   on_close = nil,

   ---@usage timeout for notifications in ms, default 5000
   timeout = 5000,

   -- Render function for notifications. See notify-render()
   render = function(bufnr, notif, ...)
      if notif.title[1] == '' then
         return require('notify.render').minimal(bufnr, notif, ...)
      else
         return require('notify.render').default(bufnr, notif, ...)
      end
   end,

   ---@usage highlight behind the window for stages that change opacity
   background_colour = 'Normal',

   ---@usage minimum width for notification windows
   minimum_width = 50,

   ---@usage Icons for the different levels
   icons = {
      ERROR = '',
      WARN = '',
      INFO = '',
      DEBUG = '',
      TRACE = '✎',
   },
}

-- no need to configure notifications in headless
if #vim.api.nvim_list_uis() == 0 then
   return
end

notify.setup(opts)
vim.notify = notify
