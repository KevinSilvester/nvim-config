local ufs = require('utils.fs')
local uv = vim.version().minor >= 10 and vim.uv or vim.loop

local M = {}

---@param buffer BufferInfo Buffer to generate node table for
---@param active boolean Is Buffer active
---@return NodeTable
function M.gen_node_table(buffer, active)
   local parent = {
      _bufnr = buffer.bufnr,
      _type = 'parent',
      text = tostring(buffer.bufnr),
      file = buffer.file,
      active = active,
   }

   -- stylua: ignore
   local children = {
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-file',       key = 'file',       value = buffer.file },
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-copilot',    key = 'copilot',    value = buffer.copilot },
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-treesitter', key = 'treesitter', value = buffer.treesitter },
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-lsp',        key = 'lsp',        value = buffer.lsp },
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-fmt',        key = 'formatters', value = buffer.formatters },
      { _bufnr = buffer.bufnr, _type = 'child', id = buffer.bufnr .. '-lint',       key = 'linters',    value = buffer.linters },
   }

   local blank = { _bufnr = buffer.bufnr, _type = 'blank', id = buffer.bufnr .. '-blank' }

   return { parent = parent, children = children, blank = blank }
end

---@param nodes_table NodeTable[]
---@param bufnr_list number[]
---@return CustomNuiTreeNode[]
function M.gen_tree_nodes(nodes_table, bufnr_list)
   local Node = require('nui.tree').Node

   local tree_nodes = {}

   for _, bufnr in ipairs(bufnr_list) do
      local node = nodes_table[bufnr]

      local child_nodes = {}
      for _, child in ipairs(node.children) do
         table.insert(child_nodes, Node(child))
      end

      local parent_node = Node(node.parent, child_nodes)
      local blank_node = Node(node.blank)

      if node.parent.active then
         table.insert(tree_nodes, 1, parent_node)
         if #bufnr_list > 0 then
            table.insert(tree_nodes, 2, blank_node)
         end
      else
         table.insert(tree_nodes, parent_node)
         table.insert(tree_nodes, blank_node)
      end
   end

   tree_nodes[#tree_nodes] = nil

   return tree_nodes
end

---@param file_path string
function M.file(file_path)
   local fp = file_path:gsub(uv.cwd() .. ufs.path_separator, '')
   if #fp > 33 then
      fp = '...' .. fp:sub(-30)
   end
   return fp
end

---@param node CustomNuiTreeNode
---@return NuiLine|nil
function M.prepare_node(node)
   local Line = require('nui.line')
   local Text = require('nui.text')

   ---@type NuiText[]
   local line_texts = {}

   if node._type == 'blank' then
      return Line()
      -- return
   end

   if node._type == 'parent' then
      -- stylua: ignore
      line_texts = {
         Text(node:is_expanded() and '' or '', 'core.cache.arrows'),
         Text(' [ ', 'core.cache.brackets'),
         Text('󰈸', node.active and 'core.cache.active' or 'core.cache.brackets'),
         Text(' ] ', 'core.cache.brackets'),
         Text('Buffer ' .. string.format('%-3s', node.text)),
      }

      if not node:is_expanded() then
         line_texts[6] = Text('', {
            virt_text = { { M.file(node.file), 'core.cache.virt_text' } },
            virt_text_pos = 'eol',
         })
      end
   end

   if node._type == 'child' then
      local value_is_table = type(node.value) == 'table'
      local value_is_boolean = type(node.value) == 'boolean'

      line_texts[1] = Text('    ', 'core.cache.arrows')
      line_texts[2] = Text(' [ ', 'core.cache.brackets')

      if (value_is_table and #node.value == 0) or node.value == false then
         line_texts[3] = Text('', 'core.cache.inactive')
      else
         line_texts[3] = Text('', 'core.cache.active')
      end

      line_texts[4] = Text(' ] ', 'core.cache.brackets')
      line_texts[5] = Text(string.format('%-10s\t', node.key), 'core.cache.brackets')

      if value_is_table then
         line_texts[6] = Text('[', 'core.cache.brackets_value')
         ---@diagnostic disable-next-line: param-type-mismatch
         line_texts[7] = Text(table.concat(node.value, ', '))
         line_texts[8] = Text(']', 'core.cache.brackets_value')
      end

      if value_is_boolean then
         line_texts[6] = Text(tostring(node.value), 'core.cache.boolean')
      end

      if not value_is_table and not value_is_boolean then
         ---@diagnostic disable-next-line: param-type-mismatch
         local val = M.file(node.value)
         line_texts[6] = Text(val)
      end
   end

   return Line(line_texts)
end

return M
