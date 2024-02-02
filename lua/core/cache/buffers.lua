local Buffer = require('core.cache.buffer')

---@alias ActiveBuffer { bufnr: number, file: string, lsp: string[], fmt: string[], treesitter: boolean, copilot: boolean }

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

function Buffers:insert(bufnr)
   if not self.list[bufnr] then
      self.list[bufnr] = Buffer:new(bufnr, vim.api.nvim_buf_get_name(bufnr))
   end
end

function Buffers:delete(bufnr)
   self.list[bufnr] = nil
end

function Buffers:refresh(bufnr)
   self.list[bufnr]:refresh()
end

function Buffers:update_active(bufnr)
   self.active = self.list[bufnr]()
end

function Buffers:exists(bufnr)
   return self.list[bufnr] ~= nil
end

return Buffers
