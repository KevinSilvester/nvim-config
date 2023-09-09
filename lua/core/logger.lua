local ufs = require('utils.fs')

---@class CoreLogger
---@field logfile string
---@field silent boolean
local Logger = {}

---Initialize Logger
---@param logfile? string path to logfile
---@param silent? boolean notify log output (default is `false`)
function Logger:init(logfile, silent)
   self = setmetatable({}, { __index = Logger })
   self.logfile = logfile or ufs.path_join(PATH.data, 'my-config.log')
   self.silent = silent or false

   --stylua: ignore
   _G.log = {
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      trace = function(origin, message, silent) self:__log('TRACE', origin, message, silent) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      debug = function(origin, message, silent) self:__log('DEBUG', origin, message, silent) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      info  = function(origin, message, silent) self:__log('INFO', origin, message, silent) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      warn  = function(origin, message, silent) self:__log('WARN', origin, message, silent) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      error = function(origin, message, silent) self:__log('ERROR', origin, message, silent) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      ---@param silent? boolean notify log output (default is `false`)
      off   = function(origin, message, silent) self:__log('OFF', origin, message, silent) end,
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

   local silent_log = false

   if silent ~= nil then
      silent_log = silent
   else
      silent_log = self.silent
   end

   if not silent_log then
      vim.notify(message, vim.log.levels[level], { title = '[' .. level .. '] ' .. origin })
   end
end

return Logger
