---@diagnostic disable: param-type-mismatch
---@enum InfoStatus
local info_status = {
   CHECKED = 'CHECKED',
   UNCHECKED = 'UNCHECKED',
   CHECKING = 'CHECKING',
}

---@alias InfoBlock { value: boolean | string[], status: InfoStatus }
---@alias BufferInfo { file: string, bufnr: number, lsp: {}, fmt: {}, treesitter: boolean, copilot: boolean }

---@class Core.BufCache.Buffer
---@field file string
---@field bufnr number
---@field lsp InfoBlock
---@field fmt InfoBlock
---@field treesitter InfoBlock
---@field copilot InfoBlock
---@operator call:BufferInfo
local Buffer = {}
Buffer.__index = Buffer
Buffer.__call = function(self)
   return {
      file = self.file,
      bufnr = self.bufnr,
      lsp = self.lsp.value,
      fmt = self.fmt.value,
      treesitter = self.treesitter.value,
      copilot = self.copilot.value,
   }
end

---@param bufnr number
---@param file string
function Buffer:new(bufnr, file)
   local cache_block = setmetatable({
      file = file,
      bufnr = bufnr,
      lsp = { value = {}, status = info_status.UNCHECKED },
      fmt = { value = {}, status = info_status.UNCHECKED },
      copilot = { value = false, status = info_status.UNCHECKED },
      treesitter = { value = false, status = info_status.UNCHECKED },
   }, self)
   return cache_block
end

---Check if treesitter highlighting is active in buffer
---@param force? boolean
function Buffer:check_treesitter(force)
   if self.treesitter.status == info_status.CHECKED and not force then
      return
   end
   self.treesitter.value = vim.treesitter.highlighter.active[self.bufnr] ~= nil
   self.treesitter.status = info_status.CHECKED
end

---Check if a LSP is attached to buffer
---@param force? boolean
function Buffer:check_lsp_and_copilot(force)
   if self.lsp.status == info_status.CHECKED and self.copilot.status == info_status.CHECKED and not force then
      return
   end
   self.lsp.status = info_status.CHECKING
   self.copilot.status = info_status.CHECKING
   self.lsp.value = {}
   self.copilot.value = false

   vim.schedule(function()
      for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = self.bufnr })) do
         if
            client.name ~= 'copilot'
            and client.name ~= 'null-ls'
            and not vim.tbl_contains(self.lsp.value, client.name)
         then
            table.insert(self.lsp.value, client.name)
         elseif client.name == 'copilot' then
            self.copilot.value = true
         end
      end

      self.lsp.status = info_status.CHECKED
      self.copilot.status = info_status.CHECKED
   end)
end

---Check if a formatter is available to the buffer
---@param force? boolean
function Buffer:check_fmt(force)
   if self.fmt.status == info_status.CHECKED and not force then
      return
   end
   self.fmt.status = info_status.CHECKING
   self.fmt.value = {}

   vim.schedule(function()
      local buf_ft = vim.bo[self.bufnr].filetype
      local ok, nl_sources = pcall(require, 'null-ls.sources')
      if not ok then
         log:warn('core.cache', 'null-ls not found!')
         return
      end
      for _, source in ipairs(nl_sources.get_available(buf_ft)) do
         if source.methods.NULL_LS_FORMATTING and not vim.tbl_contains(self.fmt.value, source.name) then
            table.insert(self.fmt.value, source.name)
         end
      end

      self.fmt.status = info_status.CHECKED
   end)
end

---Refresh cache block info
function Buffer:refresh()
   self.lsp = { value = {}, status = info_status.UNCHECKED }
   self.fmt = { value = {}, status = info_status.UNCHECKED }
   self.copilot = { value = false, status = info_status.UNCHECKED }
   self.treesitter = { value = false, status = info_status.UNCHECKED }
   self:check_treesitter(true)
   self:check_lsp_and_copilot(true)
   self:check_fmt(true)
end

return Buffer
