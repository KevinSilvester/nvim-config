local ufs = require('utils.fs')

---@class Core.Logger
---@field _logfile string
local Logger = {}
Logger.__index = Logger

---Initialize Logger
---@private
function Logger:init()
   local logger = setmetatable({
      _logfile = ufs.path_join(PATH.data, 'my-config.log'),
   }, self)

   return logger
end

---Start logger (ONCE OFF CALL)
---@param logfile string? logfile path
function Logger:start(logfile)
   if type(logfile) == 'string' then
      self._logfile = logfile
   end

   _G.log = self
end

-- function Logger:_new_log(...)
--    local args = { ... }

--    local level = args[1]
--    table.remove(args, 1)

--    local msg
--    local orgin

--    if #args == 0 then
--       return
--    end

--    if #args == 1 then
--       orgin = 'core.logger'
--       msg = type(args[1]) == 'string' and args[1] or vim.inspect(args[1])
--    else
--       assert(type(args[1]) == 'string', 'core.logger: origin must be a string')
--       orgin = args[1]
--       table.remove(args, 1)
--       msg = type(args[1]) == 'string' and args[1]
--    end

--    vim.schedule(function()
--       xpcall(function()
--          -- stylua: ignore
--          ufs.write_file(self._logfile,
--             '[' .. os.date('%X %a %d/%m/%Y') .. '] - [' .. level .. '] - - [' .. origin .. '] - ' .. message .. '\n', 'a'
--          )
--       end, function()
--          vim.notify('Failed writing to logfile', vim.log.levels.ERROR, { title = '[ERROR] core.logger' })
--       end)
--    end)
-- end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:trace(origin, message, silent)
   self:_log('TRACE', origin, message, silent)
end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:debug(origin, message, silent)
   self:_log('DEBUG', origin, message, silent)
end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:info(origin, message, silent)
   self:_log('INFO', origin, message, silent)
end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:warn(origin, message, silent)
   self:_log('WARN', origin, message, silent)
end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:error(origin, message, silent)
   self:_log('ERROR', origin, message, silent)
end

---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:off(origin, message, silent)
   self:_log('OFF', origin, message, silent)
end

---Log to logfile
---@private
---@param level 'TRACE'|'DEBUG'|'INFO'|'WARN'|'ERROR'|'OFF' log level
---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:_log(level, origin, message, silent)
   if type(message) ~= 'string' then
      message = vim.inspect(message)
   end

   vim.schedule(function()
      xpcall(function()
         -- stylua: ignore
         ufs.write_file(self._logfile,
            '[' .. os.date('%X %a %d/%m/%Y') .. '] - [' .. level .. '] - - [' .. origin .. '] - ' .. message .. '\n', 'a'
         )
      end, function()
         vim.notify('Failed writing to logfile', vim.log.levels.ERROR, { title = '[ERROR] core.logger' })
      end)
   end)

   -- luacheck: ignore
   local silent_log = false

   if type(silent) == 'boolean' then
      silent_log = silent
   end

   if not silent_log then
      local title = '[' .. level .. '] ' .. origin
      vim.notify(message, vim.log.levels[level], { title = title, id = title })
   end
end

---Dump logfile to floating window
---@param lines string[]|nil possible lines to print
function Logger:dump(lines)
   local popup_ok, Popup = pcall(require, 'nui.popup')

   if not popup_ok then
      self:error('core.logger', 'Failed to load plugin `nui`')
      return
   end

   local component
   lines = lines or vim.split(ufs.read_file(self._logfile) or '', '\n', {})

   component = Popup({
      enter = true,
      focusable = true,
      border = { style = 'rounded' },
      relative = 'editor',
      position = '50%',
      size = { width = '60%', height = '60%' },
      modifiable = true,
      buf_options = {
         readonly = false,
         filetype = 'log',
         buftype = 'nofile',
         bufhidden = 'wipe',
      },
   })

   vim.schedule(function()
      component:mount()

      component:map('n', 'q', function()
         component:unmount()
      end, { noremap = true, silent = true })

      component:on({ 'BufLeave', 'BufDelete', 'BufWinLeave' }, function()
         vim.schedule(function()
            component:unmount()
         end)
      end, { once = true })

      vim.api.nvim_buf_set_lines(component.bufnr, 0, 1, false, lines)
      vim.api.nvim_set_option_value('modifiable', false, { buf = component.bufnr })
      vim.cmd('set number')
      vim.cmd(component.bufnr .. 'b +$')
   end)
end

---Clear the log file
---@arg force? boolean force clear the log file without prompt
function Logger:clear(force)
   if force then
      ufs.write_file(self._logfile, '', 'w')
      return
   end

   vim.ui.select(vim.tbl_keys({ NO = 'NO', YES = 'YES' }), {
      prompt = 'Confirm to clear log file?',
      format_item = function(item)
         return item
      end,
   }, function(choice)
      if not choice then
         return
      end
      if choice == 'YES' then
         ufs.write_file(self._logfile, '', 'w')
      end
   end)
end

local logger_ = Logger:init()
return logger_
