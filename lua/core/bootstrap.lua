local ufs = require('utils.fs')
local uv = vim.version().minor >= 10 and vim.uv or vim.loop

---@class LockValues
---@field cache_created boolean
---@field bundled_parsers_deleted boolean
---@field parsers_downloaded boolean
---@field git_hooks_setup boolean
local LOCK_INITIALS = {
   cache_created = false,
   bundled_parsers_deleted = false,
   parsers_downloaded = false,
   git_hooks_setup = false,
}

---@class Core.Bootstrap
---@field lockfile string
---@field lock_values LockValues|nil
local Bootstrap = {}
Bootstrap.__index = Bootstrap

---Initialise Bootstrap object
---@private
function Bootstrap:init()
   local bootstrap = setmetatable({
      lockfile = ufs.path_join(PATH.config, 'bootstrap-lock.json'),
      lock_values = vim.deepcopy(LOCK_INITIALS),
   }, self)

   return bootstrap
end

---Start the bootstrap process
---@param lockfile? string
function Bootstrap:start(lockfile)
   if type(lockfile) == 'string' then
      self.lockfile = lockfile
   end

   vim.schedule(function()
      if ufs.is_file(self.lockfile) then
         self.lock_values = self:__read_lock()
      else
         log:info('core.bootstrap', 'Initialising lockfile')
         self:__write_lock(self.lock_values)
      end

      local old_lock_values = vim.deepcopy(self.lock_values)

      --  setup cache
      if not self.lock_values.cache_created then
         self.lock_values.cache_created = self:__setup_cache()
      end

      -- delete treesitter bundled parsers
      if not self.lock_values.bundled_parsers_deleted then
         self.lock_values.bundled_parsers_deleted = self:__delete_bundled_parsers()
      end

      -- setup git hooks
      if not self.lock_values.git_hooks_setup then
         self:__setup_git_hooks()
      end

      -- download pre-compiled parsers
      -- if not self.lock_values.parsers_downloaded then
      --    self:__download_parsers()
      -- end

      if not vim.deep_equal(self.lock_values, old_lock_values) then
         self:__write_lock(self.lock_values)
      end
   end)
end

---Create cache directories
---@private
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
      log:info('core.bootstrap', 'Cache setup complete')
   end, function()
      log:error('core.bootstrap', 'Cache setup failed')
   end)
end

---Delete bundled treesitter parsers
---@private
function Bootstrap:__delete_bundled_parsers()
   return xpcall(function()
      local path = string.gsub(vim.env.VIM, 'share', 'lib')
      path = ufs.path_join(path, 'parser')

      if not ufs.is_dir(path) then
         log:warn('core.bootstrap', 'Bundled parsers not found')
         return
      end

      local files = ufs.scandir(path)

      if not files then
         return
      end

      for _, file in ipairs(files) do
         uv.fs_unlink(file)
      end
      uv.fs_rmdir(path)

      log:info('core.bootstrap', 'Bundled parsers deleted')
   end, function()
      log:error('core.bootstrap', 'Parser delete failed')
   end)
end

---Bootstrap git hooks
---@private
function Bootstrap:__setup_git_hooks()
   return xpcall(function()
      log:info('core.bootstrap', 'Setting up git hooks...')

      ufs.mkdirp(ufs.path_join(PATH.config, '.git', 'hooks'))
      ufs.copy(
         ufs.path_join(PATH.config, 'scripts', 'git-hooks'),
         ufs.path_join(PATH.config, '.git', 'hooks')
      )
      self.lock_values.git_hooks_setup = true
      self:__write_lock(self.lock_values)

      log:info('core.bootstrap', 'Git hooks setup complete')
   end, function()
      log:error('core.bootstrap', 'Git hooks bootstrap failed')
   end)
end

--- TODO: Implement download parsers for new ts-parsers

---Use the download scrip to download pre-compiled parsers
-- function Bootstrap:__download_parsers()
--    vim.api.nvim_create_autocmd('User', {
--       once = true,
--       group = augroup,
--       pattern = 'warn-ts-parsers',
--       callback = function()
--          log:warn(
--             'core.bootstrap',
--             'Pre-compiled tree-sitter parsers often times are broken for linux (compiled with `zig`).\n'
--                .. 'If so they could be compiled locally by running the `./scripts/bin/ts-parsers compile-local`.\n'
--                .. 'Please note `clang`, `pnpm` and `tree-sitter-cli` is required for the script to run.'
--          )
--       end,
--    })

--    return xpcall(function()
--       log:info('core.bootstrap', 'Downloading pre-compiled treesitter parsers...')

--       local buffers = {}

--       -- temporarily stop treesitter for all buffers
--       for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--          if vim.treesitter.highlighter.active[buf] ~= nil then
--             vim.treesitter.stop(buf)
--             table.insert(buffers, buf)
--          end
--       end

--       local bin = HOST.is_win and 'ts-parsers.exe' or 'ts-parsers'
--       ufn.spawn(PATH.config .. '/scripts/bin/' .. bin, { 'download' }, function(code, _signal)
--          if code == 0 then
--             self.lock_values.parsers_downloaded = true
--             self:__write_lock(self.lock_values)
--             log:info('core.bootstrap', 'Treesitter parsers download complete!')
--             if HOST.is_linux and not HOST.is_docker then
--                vim.api.nvim_exec_autocmds('User', { group = augroup, pattern = 'warn-ts-parsers' })
--             end
--          else
--             log:error('core.bootstrap', 'Treesitter parsers download failed')
--          end

--          -- restart treesitter for all buffers
--          for _, buf in ipairs(buffers) do
--             vim.treesitter.start(buf)
--          end
--       end, { log = true })
--    end, function()
--       log:error('core.bootstrap', 'Parser download failed')
--    end)
-- end

---Attempt to read the lock file
---@private
---@return LockValues|nil
function Bootstrap:__read_lock()
   local ok, content = xpcall(function()
      local file = ufs.read_file(self.lockfile)
      assert(file, 'Failed reading lockfile')
      return vim.json.decode(file)
   end, function()
      log:error('core.bootstrap', 'Failed reading lockfile')
   end)

   return ok and content or nil
end

---Write to the lock file
---@private
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
      log:error('core.bootstrap', 'Failed writing to lockfile')
   end)
end

local bootstrap_ = Bootstrap:init()
return bootstrap_
