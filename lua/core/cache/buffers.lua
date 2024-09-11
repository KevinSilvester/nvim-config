local Buffer = require('core.cache.buffer')

---@alias ActiveBuffer BufferInfo

---@class Core.BufCache.Buffers
---@field active ActiveBuffer
---@field list Core.BufCache.Buffer[]
local Buffers = {}
Buffers.__index = Buffers

function Buffers:new()
   local buffers = { active = {}, list = {} }
   buffers = setmetatable(buffers, self)
   return buffers
end

---@param bufnr number
function Buffers:insert(bufnr)
   if not self.list[bufnr] then
      self.list[bufnr] = Buffer:new(bufnr, vim.api.nvim_buf_get_name(bufnr))
   end
end

---@param bufnr number
function Buffers:delete(bufnr)
   self.list[bufnr] = nil
end

---@param bufnr number
function Buffers:refresh(bufnr)
   self.list[bufnr]:refresh()
end

---@param bufnr number
function Buffers:update_active(bufnr)
   self.active = self.list[bufnr]()
end

---@param bufnr number
function Buffers:exists(bufnr)
   return self.list[bufnr] ~= nil
end

return Buffers
