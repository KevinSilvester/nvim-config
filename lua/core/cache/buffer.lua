---@diagnostic disable: param-type-mismatch
---@enum InfoStatus
local info_status = {
   CHECKED = 'CHECKED',
   UNCHECKED = 'UNCHECKED',
   CHECKING = 'CHECKING',
}

---@alias InfoBlock { value: boolean | string[], status: InfoStatus }
---@alias BufferInfo { file: string, bufnr: number, lsp: {}, formatters: {}, linters: {}, treesitter: boolean, copilot: boolean }

---@class Core.BufCache.Buffer
---@field file string
---@field bufnr number
---@field lsp InfoBlock
---@field formatters InfoBlock
---@field linters InfoBlock
---@field treesitter InfoBlock
---@field copilot InfoBlock
---@operator call:BufferInfo
local Buffer = {}
Buffer.__index = Buffer
Buffer.__call = function(self)
   return {
      file = self.file,
      bufnr = self.bufnr,
      lsp = vim.tbl_filter(function(v)
         return v ~= 'null-ls' and v ~= 'copilot'
      end, vim.tbl_values(self.lsp.value)),
      formatters = self.formatters.value,
      linters = self.linters.value,
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
      formatters = { value = {}, status = info_status.UNCHECKED },
      linters = { value = {}, status = info_status.UNCHECKED },
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

---Check if a LSP or null-ls is attached to buffer
---@param client_id number
function Buffer:add_lsp(client_id)
   local client = vim.lsp.get_client_by_id(client_id)
   if not client then
      self.copilot.status = info_status.CHECKED
      self.lsp.status = info_status.CHCEKED
      return
   end

   if client.name == 'copilot' then
      self.copilot.status = info_status.CHECKED
      self.copilot.value = true
   end
   if client.name == 'null-ls' then
      self:check_linters_formatters()
   end
   if not vim.tbl_contains(vim.tbl_values(self.lsp.value), client.name) then
      self.lsp.value[client_id] = client.name
   end

   self.lsp.status = info_status.CHECKED
end

---Remove LSP from buffer
---@param client_id number
function Buffer:remove_lsp(client_id)
   local client = self.lsp.value[client_id]

   if client == 'copilot' then
      self.copilot.value = false
   end

   if client == 'null-ls' then
      self.formatters.value = {}
   end

   self.lsp.value[client_id] = nil
end

---Check if a LSP is attached to buffer
---@param force? boolean
function Buffer:refresh_lsp(force)
   if self.lsp.status == info_status.CHECKED and self.copilot.status == info_status.CHECKED and not force then
      return
   end
   self.lsp.status = info_status.CHECKING
   self.copilot.status = info_status.CHECKING
   self.lsp.value = {}
   self.copilot.value = false

   vim.schedule(function()
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = self.bufnr })) do
         if client.name == 'copilot' then
            self.copilot.value = true
         end

         if client.name == 'null-ls' then
            self:check_linters_formatters()
         end

         if not vim.tbl_contains(vim.tbl_values(self.lsp.value), client.name) then
            self.lsp.value[client.id] = client.name
         end
      end
      self.lsp.status = info_status.CHECKED
      self.copilot.status = info_status.CHECKED
   end)
end

---Check if a formatter is available to the buffer
---@param force? boolean
function Buffer:check_linters_formatters(force)
   if self.formatters.status == info_status.CHECKED and not force then
      return
   end
   self.formatters.status = info_status.CHECKING
   self.formatters.value = {}
   self.linters.status = info_status.CHECKING
   self.linters.value = {}

   vim.schedule(function()
      local buf_ft = vim.bo[self.bufnr].filetype
      local ok, nl_sources = pcall(require, 'null-ls.sources')
      if not ok then
         log:warn('core.cache', 'null-ls not found!')
         return
      end
      for _, source in ipairs(nl_sources.get_available(buf_ft)) do
         if
            source.methods.NULL_LS_FORMATTING and not vim.tbl_contains(self.formatters.value, source.name)
         then
            table.insert(self.formatters.value, source.name)
         end
         if source.methods.NULL_LS_DIAGNOSTICS and not vim.tbl_contains(self.linters.value, source.name) then
            table.insert(self.linters.value, source.name)
         end
      end

      self.formatters.status = info_status.CHECKED
      self.linters.status = info_status.CHECKED
   end)
end

---Refresh cache block info
function Buffer:refresh()
   self.lsp = { value = {}, status = info_status.UNCHECKED }
   self.formatters = { value = {}, status = info_status.UNCHECKED }
   self.copilot = { value = false, status = info_status.UNCHECKED }
   self.treesitter = { value = false, status = info_status.UNCHECKED }
   self:check_treesitter(true)
   self:refresh_lsp(true)
end

return Buffer
