local ufs = require('utils.fs')

---@alias LockValues { cache_created: boolean, parsers_deleted: boolean }
---@type LockValues
local LOCK_DEFAULTS = {
   cache_created = false,
   parsers_deleted = false,
}

---@class CoreBootstrap
---@field lockfile string
---@field lock_values LockValues|nil
local Bootstrap = {}

---Initialise Bootstrap object
---@param lockfile? string
function Bootstrap:init(lockfile)
   self = setmetatable({}, { __index = Bootstrap })
   self.lockfile = lockfile or ufs.path_join(PATH.config, 'my-config-lock.json')
   self.lock_values = {}

   vim.schedule(function()
      if ufs.is_file(self.lockfile) then
         self.lock_values = self:__read_lock()
      else
         self.lock_values = vim.deepcopy(LOCK_DEFAULTS)
         log.info('core.bootstrap', 'Writing to lockfile')
         self:__write_lock(self.lock_values)
      end

      if self.lock_values == nil then
         return
      end

      local new_lock_values = vim.deepcopy(self.lock_values)

      if not self.lock_values.cache_created then
         new_lock_values.cache_created = self:__setup_cache()
      end

      if not self.lock_values.parsers_deleted then
         new_lock_values.parsers_deleted = self:__delete_bundled_parsers()
      end

      if not vim.deep_equal(self.lock_values, new_lock_values) then
         ---@diagnostic disable-next-line: param-type-mismatch
         self:__write_lock(vim.tbl_deep_extend('force', self.lock_values, new_lock_values))
      end
   end)
end

---Create cache directories
function Bootstrap:__setup_cache()
   return xpcall(function()
      local cache_dir = PATH.cache
      local cache_dirs = {
         cache_dir .. '/backup',
         cache_dir .. '/session',
         cache_dir .. '/swap',
         cache_dir .. '/view',
         cache_dir .. '/undo',
      }

      for _, d in ipairs(cache_dirs) do
         if not ufs.is_dir(d) then
            ufs.mkdir(d)
         end
      end
      log.info('core.bootstrap', 'Cache setup complete')
   end, function()
      log.error('core.bootstrap', 'Cache setup failed')
   end)
end

---Delete bundled treesitter parsers
function Bootstrap:__delete_bundled_parsers()
   return xpcall(function()
      local path = string.gsub(vim.env.VIM, 'share', 'lib')
      path = ufs.path_join(path, 'parser')

      if not ufs.is_dir(path) then
         log.warn('core.bootstrap', 'Bundled parsers not found')
         return
      end

      local files = ufs.scandir(path)

      if not files then
         return
      end

      for _, file in ipairs(files) do
         vim.loop.fs_unlink(file)
      end
      vim.loop.fs_rmdir(path)

      log.info('core.bootstrap', 'Bundled parsers deleted')
   end, function()
      log.error('core.bootstrap', 'Parser delete failed')
   end)
end

---Create a new lock file if none exists and populate with default value
---If file exists read the file and return content
---@return LockValues|nil
function Bootstrap:__read_lock()
   local ok, content = xpcall(function()
      local file = io.open(self.lockfile, 'r'):read('a')
      return vim.json.decode(file)
   end, function()
      log.error('core.bootstrap', 'Failed reading lockfile')
   end)

   return ok and content or nil
end

---Write to the lock file
---@param content LockValues
function Bootstrap:__write_lock(content)
   xpcall(function()
      local res = {}
      local tab = '   '
      for key, value in pairs(content) do
         table.insert(res, tab .. string.format('"%s": %s', key, value))
      end
      ufs.write_file(self.lockfile, '{\n' .. table.concat(res, ',\n') .. '\n}', 'w+')
   end, function()
      log.error('core.bootstrap', 'Failed writing to lockfile')
   end)
end

return Bootstrap
