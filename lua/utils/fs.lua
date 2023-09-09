local M = {}
local fn, uv = vim.fn, vim.loop

---The file system path separator for the current platform.
M.path_separator = '/'
if HOST.is_win then
   M.path_separator = '\\'
end

---check if path points to a directory
---@param path string
---@return boolean
M.is_dir = function(path)
   -- return fn.isdirectory(path) == 1
   local stat = uv.fs_stat(path)
   return stat and stat.type == 'directory' or false
end

---check path points to a file
---@param path string
---@return boolean
M.is_file = function(path)
   -- return fn.filereadable(path) == 1
   local stat = uv.fs_stat(path)
   return stat and stat.type == 'file' or false
end

---check if file/directory is a symlink
---@param path string
---@return boolean
M.is_link = function(path)
   return fn.isdirectory(path) == 2
end

---make a new directory
---@param path string new directory path
---@param mode number|nil directory permission (default 16895, equivalent of 777)
M.mkdir = function(path, mode)
   mode = mode or 16895
   uv.fs_mkdir(path, mode)
end

---list all files in a directory recursively
---@param path string source path
---@param paths table|nil list of paths
---@return table|nil list of paths
M.scandir = function(path, paths)
   local stat = uv.fs_stat(path)
   paths = paths or {}

   if not stat then
      return nil
   end

   if stat.type == 'file' then
      paths[#paths + 1] = path
   elseif stat.type == 'directory' then
      local handle = uv.fs_scandir(path)

      if not handle then
         return nil
      end

      while true do
         local name = uv.fs_scandir_next(handle)
         if not name then
            break
         end
         local new_path = M.path_join(path, name)
         M.scandir(new_path, paths)
      end
   end
   return paths
end

---Write data to a file
---@param path string can be full or relative to `cwd`
---@param txt string|table text to be written, uses `vim.inspect` internally for tables
---@param flag string used to determine access mode, common flags: "w" for `overwrite` or "a" for `append`
---@param offset number|nil specific number of bytes from the beginning of the file where the data should be written, defaults is `-1` which appends to current file offset
function M.write_file(path, txt, flag, offset)
   local data = type(txt) == 'string' and txt or vim.inspect(txt)
   uv.fs_open(path, flag, 438, function(open_err, fd)
      assert(not open_err, open_err)
      uv.fs_write(fd, data, offset, function(write_err)
         assert(not write_err, write_err)
         uv.fs_close(fd, function(close_err)
            assert(not close_err, close_err)
         end)
      end)
   end)
end

---Write data to a file
---@param path string can be full or relative to `cwd`
---@param offset number|nil specific number of bytes from the beginning of the file where the data should be read, default is `0` which will not change current file offset
---@return string|nil
M.read_file = function(path, offset)
   offset = offset == nil and 0 or offset

   ---@type string|nil
   local data

   local fd = assert(uv.fs_open(path, 'r', 438))
   local stat = assert(uv.fs_fstat(fd))
   local data = assert(uv.fs_read(fd, stat.size, offset))
   assert(uv.fs_close(fd))

   if type(data) == 'string' then
      return data
   else
      return nil
   end
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
      if arg == '' and #all_parts == 0 and not HOST.is_win then
         all_parts = { '' }
      else
         local arg_parts = M.split(arg, M.path_separator)
         vim.list_extend(all_parts, arg_parts, 1, #arg_parts)
      end
   end
   return table.concat(all_parts, M.path_separator)
end

return M
