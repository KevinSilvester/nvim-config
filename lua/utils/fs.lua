local M = {}
local fn = vim.fn

---check if path points to a directory
---@param path string
---@return boolean
M.is_dir = function(path)
   return fn.isdirectory(path) == 1
end

---check path points to a file
---@param path string
---@return boolean
M.is_file = function(path)
   return fn.filereadable(path) == 1
end

---check if file/directory is a symlink
---@param path string
---@return boolean
M.is_link = function(path)
   return fn.isdirectory(path) == 2
end

---make a new directory
---@param path string
M.mkdir = function(path)
   local cmd = function()
      if vim.g.is_win then
         return 'powershell -c "New-Item -Type directory -Path ' .. path .. '"'
      else
         return 'bash -c "mkdir -p ' .. path .. '"'
      end
   end
   vim.notify(cmd())

   os.execute(cmd())
end

return M
