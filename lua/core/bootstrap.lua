local ufs = require('utils.fs')
local ufn = require('utils.fn')

---@alias LockValues { cache_created: boolean, parsers_deleted: boolean, pasrser_downloaded: boolean }
---@type LockValues
local LOCK_INITIALS = {
   cache_created = false,
   parsers_deleted = false,
   pasrser_downloaded = false,
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
         self.lock_values = vim.deepcopy(LOCK_INITIALS)
         log.info('core.bootstrap', 'Initialising lockfile')
         self:__write_lock(self.lock_values)
      end

      local old_lock_values = vim.deepcopy(self.lock_values)

      if not self.lock_values.cache_created then
         self.lock_values.cache_created = self:__setup_cache()
      end

      if not self.lock_values.parsers_deleted then
         self.lock_values.parsers_deleted = self:__delete_bundled_parsers()
      end

      if not self.lock_values.pasrser_downloaded then
         self:__download_parsers()
      end

      if not vim.deep_equal(self.lock_values, old_lock_values) then
         self:__write_lock(self.lock_values)
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

---Use the download scrip to download pre-compiled parsers
function Bootstrap:__download_parsers()
   return xpcall(function()
      log.info('core.bootstrap', 'Downloading pre-compiled treesitter parsers...')

      local buffers = {}

      -- temporarily stop treesitter for all buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
         if vim.treesitter.highlighter.active[buf] ~= nil then
            vim.treesitter.stop(buf)
            table.insert(buffers, buf)
         end
      end

      ufn.spawn(
         'node',
         { ufs.path_join(PATH.config, 'scripts', 'ts-parsers', 'dist', 'download.mjs') },
         function(code, _signal)
            if code == 0 then
               self.lock_values.pasrser_downloaded = true
               self:__write_lock(self.lock_values)
               log.info('core.bootstrap', 'Treesitter parsers download complete!')
            else 
               log.error('core.bootstrap', 'Treesitter parsers download failed')
            end

            -- restart treesitter for all buffers
            for _, buf in ipairs(buffers) do
               vim.treesitter.start(buf)
            end
         end
      )
   end, function()
      log.error('core.bootstrap', 'Parser download failed')
   end)
end

---Attempt to read the lock file
---@return LockValues|nil
function Bootstrap:__read_lock()
   local ok, content = xpcall(function()
      local file = ufs.read_file(self.lockfile)
      assert(file, 'Failed reading lockfile')
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
