local M = {}

---check if mode is 'insert'
---@return boolean
M.is_insert_mode = function()
   return vim.api.nvim_get_mode().mode:sub(1, 1) == 'i'
end

---check if there is a word behind cursor
---@return boolean
M.has_words_before = function()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
---@param dir number 1 for forward, -1 for backward; defaults to 1
---@return boolean true if a jumpable luasnip field is found while inside a snippet
M.jumpable = function(dir)
   local luasnip_ok, luasnip = pcall(require, 'luasnip')
   if not luasnip_ok then
      return false
   end

   local win_get_cursor = vim.api.nvim_win_get_cursor
   local get_current_buf = vim.api.nvim_get_current_buf

   ---sets the current buffer's luasnip to the one nearest the cursor
   ---@return boolean true if a node is found, false otherwise
   local function seek_luasnip_cursor_node()
      -- TODO(kylo252): upstream this
      -- for outdated versions of luasnip
      if not luasnip.session.current_nodes then
         return false
      end

      local node = luasnip.session.current_nodes[get_current_buf()]
      if not node then
         return false
      end

      local snippet = node.parent.snippet
      local exit_node = snippet.insert_nodes[0]

      local pos = win_get_cursor(0)
      pos[1] = pos[1] - 1

      -- exit early if we're past the exit node
      if exit_node then
         local exit_pos_end = exit_node.mark:pos_end()
         if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
            snippet:remove_from_jumplist()
            luasnip.session.current_nodes[get_current_buf()] = nil

            return false
         end
      end

      node = snippet.inner_first:jump_into(1, true)
      while node ~= nil and node.next ~= nil and node ~= snippet do
         local n_next = node.next
         local next_pos = n_next and n_next.mark:pos_begin()
         local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
            or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

         -- Past unmarked exit node, exit early
         if n_next == nil or n_next == snippet.next then
            snippet:remove_from_jumplist()
            luasnip.session.current_nodes[get_current_buf()] = nil

            return false
         end

         if candidate then
            luasnip.session.current_nodes[get_current_buf()] = node
            return true
         end

         local ok
         ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
         if not ok then
            snippet:remove_from_jumplist()
            luasnip.session.current_nodes[get_current_buf()] = nil

            return false
         end
      end

      -- No candidate, but have an exit node
      if exit_node then
         -- to jump to the exit node, seek to snippet
         luasnip.session.current_nodes[get_current_buf()] = snippet
         return true
      end

      -- No exit node, exit from snippet
      snippet:remove_from_jumplist()
      luasnip.session.current_nodes[get_current_buf()] = nil
      return false
   end

   if dir == -1 then
      return luasnip.in_snippet() and luasnip.jumpable(-1)
   else
      return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
   end
end

--{{ Take from tailwind-tools
---@param red number
---@param green number
---@param blue number
local set_hl_from = function(red, green, blue)
   local color = string.format('%02x%02x%02x', red, green, blue)
   local hl_name = 'TailwindColorFg' .. color
   local opts

   opts = { fg = '#' .. color }

   if not vim.api.nvim_get_hl(0, { name = hl_name })[1] then
      vim.api.nvim_set_hl(0, hl_name, opts)
   end

   return hl_name
end

---@param s string
local extract_color = function(s)
   local base, _, _, r, g, b = 10, s:find('rgba?%((%d+).%s*(%d+).%s*(%d+)')

   if not r then
      base, _, _, r, g, b = 16, s:find('#(%x%x)(%x%x)(%x%x)')
   end

   if r then
      return tonumber(r, base), tonumber(g, base), tonumber(b, base)
   end
end

---@param entry cmp.Entry
---@param vim_item any
---@return any
M.lspkind_format = function(entry, vim_item)
   local doc = entry.completion_item.documentation

   if vim_item.kind == 'Color' and doc then
      local content = type(doc) == 'string' and doc or doc.value
      local r, g, b = extract_color(content)

      if r then
         vim_item.kind_hl_group = set_hl_from(r, g, b)
      end
   end

   return vim_item
end
--}}

return M
