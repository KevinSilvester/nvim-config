local M = {}
local fn = vim.fn

---The file system path separator for the current platform.
M.path_separator = '/'
if vim.g.is_win then
   M.path_separator = '\\'
end

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
         return 'powershell -c "New-Item -Type directory -Path ' .. path .. ' 2>&1 | Out-Null"'
      else
         return 'bash -c "mkdir -p ' .. path .. ' $>/dev/null"'
      end
   end
   os.execute(cmd())
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
   local fields = {}

   local pattern = string.format('([^%s]+)', sep)
   local _ = string.gsub(inputString, pattern, function(c)
      fields[#fields + 1] = c
   end)

   return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
   local args = { ... }
   if #args == 0 then
      return ''
   end

   local all_parts = {}
   if type(args[1]) == 'string' and args[1]:sub(1, 1) == M.path_separator then
      all_parts[1] = ''
   end

   for _, arg in ipairs(args) do
      arg_parts = M.split(arg, M.path_separator)
      vim.list_extend(all_parts, arg_parts)
   end
   return table.concat(all_parts, M.path_separator)
end

return M
