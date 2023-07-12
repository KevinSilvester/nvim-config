---@alias MapperMode string|string[]
---@alias MapperOpts { silent?: boolean, noremap?: boolean, nowait?: boolean, expr?: boolean, desc?: string }
---@alias MapperMapping table<string, string|function, MapperOpts>

local M = {}

---@class MapperOpts
local Opts = {}

function Opts:new(instance)
   instance = instance
      or {
         options = {
            silent = false,
            nowait = false,
            expr = false,
            noremap = false,
         },
      }
   setmetatable(instance, self)
   self.__index = self
   return instance
end

function M.silent(opt)
   return function()
      opt.silent = true
   end
end

function M.noremap(opt)
   return function()
      opt.noremap = true
   end
end

function M.expr(opt)
   return function()
      opt.expr = true
   end
end

function M.remap(opt)
   return function()
      opt.remap = true
   end
end

function M.nowait(opt)
   return function()
      opt.nowait = true
   end
end

function M.opts(...)
   local args = { ... }
   local o = Opts:new()

   if #args == 0 then
      return o.options
   end

   for _, arg in pairs(args) do
      if type(arg) == 'string' then
         o.options.desc = arg
      else
         arg(o.options)()
      end
   end
   return o.options
end

---@param str string
---@return string
M.cmd = function(str)
   return '<cmd>' .. str .. '<CR>'
end

---@private
---@param mode MapperMode vim mode
---@param buffer? number buffer number
---@param mappings MapperMapping|MapperMapping[]
local _set_keymap = function(mode, buffer, mappings)
   -- check if multiple mappings need to be set
   local has_multiple = type(mappings[1]) == 'table' and type(mappings[2]) == 'table'

   -- set keymaps
   if has_multiple then
      for _, mapping in ipairs(mappings) do
         if #mapping < 2 then
            log.warn('core.mapper', 'Invalid keymap for `' .. mapping[1] .. '`')
            goto continue
         end
         local o = mapping[3] or M.opts()
         if type(buffer) == 'number' then
            o = vim.tbl_extend('force', o, { buffer = buffer })
         end
         vim.keymap.set(mode, mapping[1], mapping[2], o)
         ::continue::
      end
   else
      if #mappings < 2 then
         log.warn('core.mapper', 'Invalid keymap for `' .. mappings[1] .. '`')
         return
      end
      local o = mappings[3] or M.opts()
      if type(buffer) == 'number' then
         o = vim.tbl_extend('force', o, { buffer = buffer })
      end
      vim.keymap.set(mode, mappings[1], mappings[2], o)
   end
end

---@private
---@param mode MapperMode vim mode
---@param buf_map? boolean map key bindings to specific buffer
local _map = function(mode, buf_map)
   if buf_map then
      ---@param buffer number
      ---@param mappings MapperMapping|MapperMapping[]
      return function(buffer, mappings)
         _set_keymap(mode, buffer, mappings)
      end
   else
      ---@param mappings MapperMapping|MapperMapping[]
      return function(mappings)
         _set_keymap(mode, nil, mappings)
      end
   end
end

M.nmap = _map('n')
M.imap = _map('i')
M.cmap = _map('c')
M.vmap = _map('v')
M.xmap = _map('x')
M.tmap = _map('t')

M.buf_nmap = _map('n', true)
M.buf_imap = _map('i', true)
M.buf_cmap = _map('c', true)
M.buf_vmap = _map('v', true)
M.buf_xmap = _map('x', true)
M.buf_tmap = _map('t', true)

return M
