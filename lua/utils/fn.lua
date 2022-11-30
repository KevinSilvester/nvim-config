local fn = vim.fn

local M = {}

M.is_latest = function()
   return vim.version().minor <= 8
end

---check whether executable is callable
---@param name string name of executable
---@return boolean
M.executable = function(name)
   return fn.executable(name) == 1
end

---check whether a feature exists in Nvim
---@param feat string the feature name, like `nvim-0.7` or `unix`
---@return boolean
M.has = function(feat)
   return fn.has(feat) == 1
end

---print vim.inspect output to a popup window/buffer
---@param input any input can by anything that vim.inspect is able to parse
---@param yank boolean|nil wheather to copy the ouput to clipboard
---@param open_split boolean|nil whether to use popup window
---@return nil
M.inspect = function(input, yank, open_split)
   local popup_ok, Popup = pcall(require, 'nui.popup')
   local split_ok, Split = pcall(require, 'nui.split')

   if input == nil then
      vim.notify('No input provided', vim.log.levels.WARN, { title = 'nvim-config' })
      return
   end
   if not popup_ok or not split_ok then
      vim.notify("Failed to load 'nui' modules", vim.log.levels.ERROR, { title = 'nvim-config' })
      return
   end

   open_split = (open_split == nil) and false or open_split
   yank = (yank == nil) and false or yank

   local output = vim.inspect(input)
   local component

   if open_split then
      component = Split({
         enter = true,
         relative = 'win',
         position = 'bottom',
         size = '20%',
         buf_options = { modifiable = true, readonly = false },
      })
   else
      component = Popup({
         enter = true,
         focusable = true,
         border = { style = 'rounded' },
         position = '50%',
         size = { width = '80%', height = '60%' },
         buf_options = { modifiable = true, readonly = false },
      })
   end

   ---@diagnostic disable-next-line: param-type-mismatch
   vim.defer_fn(function()
      component:mount()

      component:map('n', 'q', function()
         component:unmount()
      end, { noremap = true })

      component:on({ 'BufLeave', 'BufDelete', 'BufWinLeave' }, function()
         vim.schedule(function()
            component:unmount()
         end)
      end, { once = true })

      vim.api.nvim_buf_set_lines(component.bufnr, 0, 1, false, vim.split(output, '\n'))

      if yank then
         vim.cmd(component.bufnr .. 'b +%y')
      end
      ---@diagnostic disable-next-line: param-type-mismatch
   end, 750)
end

return M
