local ufs = require('utils.fs')

---@alias LockValues { cache_created: boolean }
---@type LockValues
local LOCK_DEFAULTS = { cache_created = false }

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
         self.lock_values = self:read_lock()
      else
         self.lock_values = vim.deepcopy(LOCK_DEFAULTS)
         log.debug('core.bootstrap', 'Writing to lockfile')
         self:write_lock(self.lock_values)
      end

      if self.lock_values == nil then
         return
      end

      local new_lock_values = vim.deepcopy(self.lock_values)

      if not self.lock_values.cache_created then
         new_lock_values.cache_created = self:setup_cache()
      end

      if not vim.deep_equal(self.lock_values, new_lock_values) then
         self:write_lock(vim.tbl_deep_extend('force', self.lock_values, new_lock_values))
      end
   end)
end

---Create cache directories
function Bootstrap:setup_cache()
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
function Bootstrap:delete_bundled_parsers()
   local path = string.gsub(vim.env.VIM, 'share', 'lib')
   path = ufs.path_join(path, 'parser')

   if not ufs.is_dir(path) then
      return
   end

   local files = ufs.scandir(path)
   ufs.write_file(ufs.path_join(PATH.config, 'file1'), path, 'w')
   ufs.write_file(ufs.path_join(PATH.config, 'file2'), files, 'w')

   -- for _, file in ipairs(files) do
   --    vim.loop.fs_unlink(file, function(err, _)
   --       if err ~= nil then
   --          vim.notify(
   --             'Failed to delete bundled parser: ' .. file .. ' ' .. err,
   --             vim.log.levels.ERROR,
   --             { title = 'nvim-config' }
   --          )
   --       end
   --    end)
   -- end

   -- vim.loop.fs_rmdir(path, function(err, _)
   --    if err ~= nil then
   --       vim.notify(
   --          'Failed to remove bundled Tree-Sitter parsers!',
   --          vim.log.levels.ERROR,
   --          { title = 'nvim-config' }
   --       )
   --    end
   -- end)
end

---Create a new lock file if none exists and populate with default value
---If file exists read the file and return content
---@return LockValues|nil
function Bootstrap:read_lock()
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
function Bootstrap:write_lock(content)
   xpcall(function()
      ufs.write_file(self.lockfile, vim.json.encode(content), 'w+')
   end, function()
      log.error('core.bootstrap', 'Failed writing to lockfile')
   end)
end

return Bootstrap
