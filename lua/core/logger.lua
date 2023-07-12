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
      trace = function(origin, message) self:__log('TRACE', origin, message) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      debug = function(origin, message) self:__log('DEBUG', origin, message) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      info  = function(origin, message) self:__log('INFO', origin, message) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      warn  = function(origin, message) self:__log('WARN', origin, message) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      error = function(origin, message) self:__log('ERROR', origin, message) end,
      ---@param origin string origin of logged message
      ---@param message any message to be logged
      off   = function(origin, message) self:__log('OFF', origin, message) end,
   }
end

---Log to logfile
---@param level 'TRACE'|'DEBUG'|'INFO'|'WARN'|'ERROR'|'OFF' log level
---@param origin string origin of logged message
---@param message any message to be logged
function Logger:__log(level, origin, message)
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

   if not self.silent then
      vim.notify(message, vim.log.levels[level], { title = '[' .. level .. '] ' .. origin })
   end
end

return Logger
