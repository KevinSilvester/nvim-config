local function augroup(name)
   return vim.api.nvim_create_augroup('core.cache.' .. name, { clear = true })
end

local function hlgroup(name)
   return 'core.cache.' .. name
end

---@alias CacheBlock { file: string, lsp: string[], fmt: string[], treesitter: boolean, copilot: boolean }
---@alias ActiveCacheBlock { number: number, file: string, lsp: string[], fmt: string[], treesitter: boolean, copilot: boolean }
---@type { active: number, buffers: CacheBlock[] }

---@class CoreBufCache
---@field active ActiveCacheBlock
---@field buffers CacheBlock[]
local BufCache = {}
BufCache.__index = BufCache

---Initialise BufCache
function BufCache:init()
   local buf_cache_ = setmetatable({
      active = {},
      buffers = {},
      excluded = { 'help', 'netrw', 'NvimTree', 'mason', 'lazy', 'toggleterm', 'alpha', 'TelescopePropmt' },
   }, self)

   buf_cache_:__create_autocmds()
   buf_cache_:__create_hl()
   _G.buf_cache = buf_cache_
end

---Update active buffer info
---@private
---@param bufnr number bufnr of new active buffer
function BufCache:__update_active(bufnr)
   if self.buffers[bufnr] then
      self.active = vim.tbl_extend('force', self.buffers[bufnr], { number = bufnr })
   end
end

---Create new `CacheBlock`
---@private
---@param bufnr number bufnr of entered buffer
---@param file string path to buffer file
function BufCache:__create_block(bufnr, file)
   if not self.buffers[bufnr] and file ~= '' then
      self.buffers[bufnr] = { lsp = {}, fmt = {}, file = file, copilot = false, treesitter = false }
   end
end

---Delete `CacheBlock`
---@private
---@param bufnr number bufnr of cache block
function BufCache:__delete_block(bufnr)
   self.buffers[bufnr] = nil
end

---Deleted cache blocks for excluded filetypes
---@private
---@param bufnr number
function BufCache:__delete_excluded_ft(bufnr)
   if self.buffers[bufnr] and vim.tbl_contains(self.excluded, vim.bo[bufnr].filetype) then
      self:__delete_block(bufnr)
   end
end

---Check if treesitter highlighting is active in buffer
---@private
---@param bufnr number
function BufCache:__check_treesitter(bufnr)
   if not self.buffers[bufnr] then
      return
   end
   self.buffers[bufnr].treesitter = vim.treesitter.highlighter.active[bufnr] ~= nil
end

---Check if a LSP is attached to buffer
---@private
---@param bufnr number
function BufCache:__check_lsp(bufnr)
   if not self.buffers[bufnr] then
      return
   end

   vim.schedule(function()
      for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
         if
            client.name ~= 'copilot'
            and client.name ~= 'null-ls'
            and not vim.tbl_contains(self.buffers[bufnr].lsp, client.name)
         then
            table.insert(self.buffers[bufnr].lsp, client.name)
         elseif client.name == 'copilot' then
            self.buffers[bufnr].copilot = true
         end
      end
   end)
end

---Check if a formatter is available to the buffer
---@private
---@param bufnr number
function BufCache:__check_fmt(bufnr)
   if not self.buffers[bufnr] then
      return
   end

   vim.schedule(function()
      local buf_ft = vim.bo[bufnr].filetype
      local ok, nl_sources = pcall(require, 'null-ls.sources')
      if not ok then
         log.warn('core.cache', 'null-ls not found!')
         return
      end

      for _, source in ipairs(nl_sources.get_available(buf_ft)) do
         if
            source.methods.NULL_LS_FORMATTING
            and not vim.tbl_contains(self.buffers[bufnr].fmt, source.name)
         then
            table.insert(self.buffers[bufnr].fmt, source.name)
         end
      end
   end)
end

---Create autocmd to track buffers
---@private
function BufCache:__create_autocmds()
   vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = augroup('active-buffer'),
      desc = 'Update active buffer',
      callback = function(event)
         self:__create_block(event.buf, event.file)
         self:__update_active(event.buf)
      end,
   })

   vim.api.nvim_create_autocmd({ 'BufLeave', 'BufHidden', 'BufDelete' }, {
      group = augroup('delete-excluded'),
      desc = 'Delete cache block for excluded filetypes',
      callback = function(event)
         self:__delete_excluded_ft(event.buf)
      end,
   })

   vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      group = augroup('treesitter'),
      desc = 'Cache buf treesitter',
      callback = vim.schedule_wrap(function(event)
         self:__check_treesitter(event.buf)
         self:__update_active(event.buf)
      end),
   })

   vim.api.nvim_create_autocmd({ 'BufDelete' }, {
      group = augroup('delete-block'),
      desc = 'Update active buffer',
      callback = vim.schedule_wrap(function(event)
         self:__delete_block(event.buf)
      end),
   })

   vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
      group = augroup('lsp+fmt+copilot'),
      desc = 'Cache buf LSP+FMT+Copilot',
      callback = vim.schedule_wrap(function(event)
         self.buffers[event.buf].lsp = {}
         self.buffers[event.buf].fmt = {}
         self.buffers[event.buf].copilot = false

         self:__check_lsp(event.buf)
         self:__check_fmt(event.buf)

         if event.buf == self.active.number then
            self:__update_active(event.buf)
         end
      end),
   })
end

---Create highlight groups
---@private
function BufCache:__create_hl()
   local hl_groups = {
      text = { link = 'Normal' },
      brackets = { fg = '#6c7086' },
      brackets_value = { fg = '#caa6f7' },
      arrows = { link = 'GitSignsChange' },
      active = { fg = '#64f5b8', bold = true },
      inactive = { fg = '#f54a47', bold = true },
      boolean = { link = '@boolean' },
      virt_text = { link = 'Folded' },
   }

   for name, value in pairs(hl_groups) do
      vim.api.nvim_set_hl(0, hlgroup(name), value)
   end
end

---Render BufCache info to popup window
function BufCache:render()
   local popup_ok, Popup = pcall(require, 'nui.popup')
   local tree_ok, Tree = pcall(require, 'nui.tree')
   local line_ok, Line = pcall(require, 'nui.line')

   if not (popup_ok or tree_ok or line_ok) then
      log.error('core.cache.render', 'failed to load `nui.nvim`')
   end

   -- create tree node
   local tree_nodes = {}

   ---@param bufnr number
   ---@param cache_block CacheBlock
   ---@param key string
   ---@return NuiTreeNode
   local create_child_node = function(bufnr, cache_block, key)
      return Tree.Node({ id = bufnr .. '-' .. key, key = key, value = cache_block[key] })
   end

   ---@param node NuiTreeNode
   ---@param cache_block CacheBlock
   local update_child_node = function(node, cache_block)
      node.value = cache_block[node.key]
   end

   ---@param bufnr number
   ---@param buffer_count number
   ---@param cache_block CacheBlock
   ---@param nodes table
   --TODO: Prevent blank node on after last parent node
   local create_parent_node = function(bufnr, buffer_count, cache_block, nodes)
      local is_buffer_active = self.active.number == bufnr
      -- local is_last_parent =

      local children = {
         create_child_node(bufnr, cache_block, 'file'),
         create_child_node(bufnr, cache_block, 'copilot'),
         create_child_node(bufnr, cache_block, 'treesitter'),
         create_child_node(bufnr, cache_block, 'lsp'),
         create_child_node(bufnr, cache_block, 'fmt'),
      }

      local parent =
         Tree.Node({ text = tostring(bufnr), file = cache_block.file, active = is_buffer_active }, children)
      local blank = Tree.Node({ id = bufnr .. '-blank', blank = true })

      if is_buffer_active then
         table.insert(nodes, 1, parent)
         if buffer_count > 1 then
            table.insert(nodes, 2, blank)
         end
      else
         table.insert(nodes, parent)
         table.insert(nodes, blank)
      end
   end

   local bufnr_list = vim.tbl_keys(self.buffers)
   for _, bufnr in ipairs(bufnr_list) do
      create_parent_node(bufnr, #bufnr_list, self.buffers[bufnr], tree_nodes)
   end

   --
   -----------------------
   -- Instantiate popup --
   -----------------------
   local popup = Popup({
      enter = true,
      focusable = true,
      zindex = 1000,
      border = { style = 'rounded', text = { top = 'BufCache', bottom = "'?' for help" } },
      relative = 'editor',
      position = '50%',
      size = { height = '50%', width = '45%' },
      buf_options = { modifiable = false, readonly = false },
   })

   popup:mount()

   --
   -----------------------
   -- Popup Close Event --
   -----------------------
   popup:on(
      { 'BufLeave', 'BufDelete', 'BufWinLeave' },
      vim.schedule_wrap(function()
         popup:unmount()
      end),
      { once = true }
   )

   --
   ----------------------
   -- Instantiate tree --
   ----------------------
   local tree = Tree({
      winid = popup.winid,
      nodes = tree_nodes,
      prepare_node = function(node)
         local line = Line()

         if node.blank == true then
            return line
         end

         local file_path = vim.fn.fnamemodify(node.key == 'file' and node.value or node.file, ':~')
         if #file_path > 33 then
            file_path = '...' .. file_path:sub(-30)
         end

         -- Buffer (parent) nodes
         if node:has_children() then
            line:append(node:is_expanded() and '' or '', hlgroup('arrows'))
            line:append(' [ ', hlgroup('brackets'))
            line:append('󰈸', node.active and hlgroup('active') or hlgroup('brackets'))
            line:append(' ] ', hlgroup('brackets'))
            line:append('Buffer ' .. string.format('%-3s', node.text))

            if not node:is_expanded() then
               line:append('', {
                  virt_text = { { file_path, hlgroup('virt_text') } },
                  virt_text_pos = 'eol',
               })
            end
            return line
         end

         -- Buffer info (child) nodes
         local value_is_table = type(node.value) == 'table'
         local value_is_boolean = type(node.value) == 'boolean'

         local str_value
         if value_is_table then
            str_value = table.concat(node.value, ', ')
         elseif node.key == 'file' then
            str_value = file_path
         else
            str_value = tostring(node.value)
         end

         line:append('    ', hlgroup('arrows'))
         line:append(' [ ', hlgroup('brackets'))
         if (value_is_table and #node.value == 0) or node.value == false then
            line:append('', hlgroup('inactive'))
         else
            line:append('', hlgroup('active'))
         end
         line:append(' ] ', hlgroup('brackets'))
         line:append(string.format('%-10s\t', node.key), hlgroup('brackets'))

         if value_is_table then
            line:append('[ ', hlgroup('brackets_value'))
            line:append(str_value)
            line:append(' ]', hlgroup('brackets_value'))
         elseif value_is_boolean then
            line:append(str_value, hlgroup('boolean'))
         else
            line:append(str_value)
         end

         return line
      end,
   })

   --
   ----------------------------
   -- Popup+Tree keybindings --
   ----------------------------

   -- Close/exit
   popup:map('n', { 'q', '<esc>' }, function()
      -- stylua: ignore
      vim.schedule(function() popup:unmount() end)
   end, { noremap = true, silent = true })

   -- Expand
   popup:map('n', 'l', function()
      local node, linenr = tree:get_node()
      if node == nil or linenr == nil then
         return
      end

      if not node:has_children() then
         node, linenr = tree:get_node(node:get_parent_id())
      end

      if node and node:expand() then
         if node.checked then
            return
         end

         node.checked = true
         vim.api.nvim_win_set_cursor(popup.winid, { linenr, 0 })
         vim.schedule(function()
            tree:render()
         end)
      end
   end, { noremap = true, silent = true })

   -- Expand all
   popup:map('n', 'L', function()
      local nodes = tree:get_nodes()

      for _, node in ipairs(nodes) do
         if node:has_children() and node:expand() then
            node.checked = true
         end
      end

      vim.schedule(function()
         tree:render()
      end)
   end, { noremap = true, silent = true })

   -- Collapse
   popup:map('n', 'h', function()
      local node, linenr = tree:get_node()
      if node == nil or linenr == nil then
         return
      end

      if not node:has_children() then
         node, linenr = tree:get_node(node:get_parent_id())
      end
      if node and node:collapse() then
         if not node.checked then
            return
         end

         node.checked = false
         vim.api.nvim_win_set_cursor(popup.winid, { linenr, 0 })
         vim.schedule(function()
            tree:render()
         end)
      end
   end, { noremap = true, silent = true })

   -- Collapse all
   popup:map('n', 'H', function()
      local nodes = tree:get_nodes()

      for _, node in ipairs(nodes) do
         if node:has_children() and node:collapse() then
            node.checked = false
         end
      end

      vim.schedule(function()
         tree:render()
      end)
   end, { noremap = true, silent = true })

   -- Open buffer
   popup:map('n', 'o', function()
      local node = tree:get_node()
      if node == nil then
         return
      end

      if not node:has_children() then
         node = tree:get_node(node:get_parent_id())
      end

      if node and node.file then
         vim.schedule(function()
            popup:unmount()
            vim.api.nvim_set_current_buf(tonumber(node.text))
         end)
      end
   end, { noremap = true, silent = true })

   -- Delete buffer
   popup:map('n', 'd', function()
      local node = tree:get_node()
      if node == nil then
         return
      end

      if not node:has_children() then
         node = tree:get_node(node:get_parent_id())
      end

      if node and node.file then
         vim.schedule(function()
            popup:unmount()
            popup:mount()
            vim.api.nvim_buf_delete(tonumber(node.text), { force = false })
         end)
      end
   end, { noremap = true, silent = true })

   -- Force delete buffer
   popup:map('n', 'D', function()
      local node = tree:get_node()
      if node == nil then
         return
      end

      if not node:has_children() then
         node = tree:get_node(node:get_parent_id())
      end

      if node and node.file then
         vim.schedule(function()
            -- popup:unmount()
            vim.api.nvim_buf_delete(tonumber(node.text), { force = true })
         end)
      end
   end, { noremap = true, silent = true })

   -- Refresh
   popup:map('n', 'r', function()
      self:refresh_all()
      local all_nodes = tree:get_nodes()
      ---@type { id: string, text: string}[]
      local parent_nodes = {}

      for _, node in ipairs(all_nodes) do
         if node:has_children() then
            table.insert(parent_nodes, { id = node:get_id(), text = node.text })
         end
      end

      vim.schedule(function()
         for _, parent in ipairs(parent_nodes) do
            local children = tree:get_nodes(parent.id)
            for _, child in ipairs(children) do
               update_child_node(child, self.buffers[tonumber(parent.text)])
            end
         end
         tree:render()
      end)
   end, { noremap = true, silent = true })

   -- Print Keybingings Help
   popup:map('n', '?', function()
      local help_text = {
         'Buffer Info',
         '',
         'Keybindings:',
         '',
         '  <esc> or q: Close',
         '  l: Expand',
         '  L: Expand all',
         '  h: Collapse',
         '  H: Collapse all',
         '  o: Open buffer',
         '  r: Refresh all buffer info',
         '  d: Delete buffer',
         '  D: Force delete buffer',
      }
      local help_popup = Popup({
         enter = true,
         focusable = true,
         zindex = 2000,
         border = { style = 'rounded', text = { top = 'BufCache Help' } },
         relative = 'editor',
         position = '50%',
         size = { height = #help_text + 2, width = '35%' },
         buf_options = { modifiable = true, readonly = true },
      })

      help_popup:on({ 'BufLeave', 'BufDelete', 'BufWinLeave' }, function()
         vim.schedule(function()
            help_popup:unmount()
         end)
      end, { once = true })

      help_popup:map('n', { 'q', '<esc>' }, function()
         help_popup:unmount()
      end, { noremap = true, silent = true })

      vim.schedule(function()
         help_popup:mount()

         vim.api.nvim_buf_set_lines(help_popup.bufnr, 0, -1, false, help_text)
         vim.api.nvim_buf_set_option(help_popup.bufnr, 'modifiable', false)
      end)
   end, { noremap = true, silent = true })

   tree:render()
end

---Refresh buf cache for active buffer
function BufCache:refresh()
   ---@type number
   local bufnr = vim.api.nvim_get_current_buf()

   self.buffers[bufnr].lsp = {}
   self.buffers[bufnr].fmt = {}
   self.buffers[bufnr].copilot = false

   self:__check_treesitter(bufnr)
   self:__check_lsp(bufnr)
   self:__check_fmt(bufnr)
   self:__update_active(bufnr)
end

---Refresh buf cache for all buffers
function BufCache:refresh_all()
   ---@type number[]
   local bufnr_list = vim.tbl_keys(self.buffers)

   for _, bufnr in ipairs(bufnr_list) do
      self.buffers[bufnr].lsp = {}
      self.buffers[bufnr].fmt = {}
      self.buffers[bufnr].copilot = false

      self:__check_treesitter(bufnr)
      self:__check_lsp(bufnr)
      self:__check_fmt(bufnr)
      self:__update_active(bufnr)
   end
end

return BufCache
