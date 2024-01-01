local ufs = require('utils.fs')

---@class CoreLogger
---@field logfile string
---@field silent boolean
local Logger = {}
Logger.__index = Logger

---Initialize Logger
---@param logfile? string path to logfile
---@param silent? boolean notify log output (default is `false`)
function Logger:init(logfile, silent)
   local logger = setmetatable({
      logfile = logfile or ufs.path_join(PATH.data, 'my-config.log'),
      silent = silent or false,
   }, self)

   --stylua: ignore
   _G.log = {
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      trace = function(origin, message, silent_) logger:__log('TRACE', origin, message, silent_) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      debug = function(origin, message, silent_) logger:__log('DEBUG', origin, message, silent_) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      info  = function(origin, message, silent_) logger:__log('INFO', origin, message, silent_) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      warn  = function(origin, message, silent_) logger:__log('WARN', origin, message, silent_) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      error = function(origin, message, silent_) logger:__log('ERROR', origin, message, silent_) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent_? boolean notify log output (default is `false`)
      off   = function(origin, message, silent_) logger:__log('OFF', origin, message, silent_) end,
   }
end

---Log to logfile
---@param level 'TRACE'|'DEBUG'|'INFO'|'WARN'|'ERROR'|'OFF' log level
---@param origin string origin of logged message
---@param message any message to be logged
---@param silent? boolean notify log output (default is `false`)
function Logger:__log(level, origin, message, silent)
   if type(message) ~= 'string' then
      message = vim.inspect(message)
   end

   vim.schedule(function()
      xpcall(function()
         ufs.write_file(
            self.logfile,
            '[' .. os.date('%X-%a-%x') .. '] - [' .. level .. '] - - [' .. origin .. '] - ' .. message .. '\n',
            'a'
         )
      end, function()
         vim.notify('Failed writing to logfile', vim.log.levels.ERROR, { title = '[ERROR] core.config' })
      end)
   end)

   -- luacheck: ignore
   local silent_log = false

   if type(silent) == 'boolean' then
      silent_log = silent
   else
      silent_log = self.silent
   end

   if not silent_log then
      vim.notify(message, vim.log.levels[level], { title = '[' .. level .. '] ' .. origin })
   end
end

return Logger
