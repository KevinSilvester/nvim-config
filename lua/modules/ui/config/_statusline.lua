local lualine = require('lualine')

local colours = {
   red = '#f38ba8',
   green = '#92CDE7',
}

local ACTIVE_LSP = {}
local ACTIVE_FMT = {}
local COPILOT_ACTIVE = false

local function get_active_lsp()
   local buf_lsp_names = {}

   -- add lsp clients
   for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      if client.name ~= 'copilot' and client.name ~= 'null-ls' then
         table.insert(buf_lsp_names, client.name)
      end
      if client.name == 'copilot' then
         COPILOT_ACTIVE = true
      end
   end

   return vim.fn.uniq(buf_lsp_names)
end

local function get_active_fmt()
   local buf_ft = vim.bo.filetype
   local available_sources = require('null-ls.sources').get_available(buf_ft)
   local buf_fmt_names = {}

   -- add formatter
   for _, source in ipairs(available_sources) do
      for _ in pairs(source.methods) do
         table.insert(buf_fmt_names, source.name)
      end
   end

   return vim.fn.uniq(buf_fmt_names)
end

---@param tbl table
---@return string
local function table_to_string(tbl)
   local str_tokens = {}

   for i, val in ipairs(tbl) do
      table.insert(str_tokens, i .. '. ')
      table.insert(str_tokens, val)
      table.insert(str_tokens, '\n')
   end

   return table.concat(str_tokens, '')
end

local mode = {
   function()
      return ''
   end,
   separator = { left = '', right = '' },
}

local filename = {
   'filename',
   icon = '',
   color = { bg = '#212430', fg = '#b4befe', gui = 'bold' },
   separator = { left = '', right = '' },
}

local branch = {
   'branch',
   icon = '',
   color = { bg = '#212430', fg = '#b4befe', gui = 'bold' },
   separator = { left = '', right = '' },
}

local diff = {
   'diff',
   source = function()
      ---@diagnostic disable-next-line: undefined-field
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
         return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
         }
      end
   end,
   colored = true,
   padding = { left = 0, right = 1 },
   symbols = { added = '  ', modified = ' ', removed = ' ' },
   color = { bg = '#212430' },
   separator = { left = '', right = '' },
}

local info = {
   function()
      return ''
   end,
   color = { bg = '#8FCDA9', fg = '#121319' },
   separator = { left = '', right = '' },
}

local diagnostics = {
   'diagnostics',
   sources = { 'nvim_lsp' },
   sections = {
      'info',
      'error',
      'warn',
      'hint',
   },
   diagnostic_color = {
      error = { fg = '#820e2d', bg = '#0f111a' },
      warn = { fg = 'DiagnosticWarn', bg = '#0f111a' },
      info = { fg = 'DiaganosticInfo', bg = '#0f111a' },
      hint = { fg = '#92CDE7', bg = '#0f111a' },
   },
   colored = true,
   update_in_insert = true,
   always_visible = true,
   symbols = {
      error = ' ',
      warn = ' ',
      hint = ' ',
      info = ' ',
   },
   separator = { left = '', right = '' },
}

local copilot = {
   function()
      return ' '
   end,
   separator = '',
   padding = 0,
   color = { fg = COPILOT_ACTIVE and colours.green or colours.red },
}

local treesitter = {
   function()
      return ' '
   end,
   separator = '',
   padding = 1,
   color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and colours.green or colours.red, gui = 'bold' }
   end,
}

local fmt = {
   function()
      return ' ' .. #ACTIVE_FMT
   end,
   color = function()
      ACTIVE_FMT = get_active_fmt()
      return { fg = #ACTIVE_FMT > 0 and colours.green or colours.red, gui = 'bold' }
   end,
   padding = 0,
   separator = '',
   on_click = function()
      if #ACTIVE_FMT > 0 then
         local str = table_to_string(ACTIVE_FMT)
         vim.notify(str, vim.log.levels.INFO, { title = 'Active Formatter' })
      else
         vim.notify('No formatters active', vim.log.levels.ERROR, { title = 'Active Formatter' })
      end
   end,
}

local lsp = {
   function()
      return ' ' .. #ACTIVE_LSP
   end,
   color = function()
      ACTIVE_LSP = get_active_lsp()
      return { fg = #ACTIVE_LSP > 0 and colours.green or colours.red, gui = 'bold' }
   end,
   separator = '',
   on_click = function()
      if #ACTIVE_LSP > 0 then
         local str = table_to_string(ACTIVE_LSP)
         vim.notify(str, vim.log.levels.INFO, { title = 'Active LSP' })
      else
         vim.notify('No LSP active', vim.log.levels.ERROR, { title = 'Active LSP' })
      end
   end,
}

local fileformat = {
   'fileformat',
   symbols = {
      unix = ' ', -- ebc6
      mac = ' ', -- e302
      dos = ' ', -- e70f
   },
   color = { bg = '#8FCDA9', fg = '#121319' },
   separator = { left = '', right = '' },
}

local filesize = {
   'filesize',
   icon = '',
   color = { bg = '#212430', fg = '#b4befe', gui = 'bold' },
   separator = { left = '', right = '' },
}

local filetype = {
   'filetype',
   colored = true,
   color = { bg = '#212430', fg = '#b4befe', gui = 'bold' },
   separator = { left = '', right = '' },
}

local location = {
   function()
      local line = vim.fn.line('.')
      local total = vim.fn.line('$')
      return string.format(' %d/%d', line, total)
   end,
   on_click = function()
      local line = vim.fn.line('.')
      local col = vim.fn.virtcol('.')
      local total = vim.fn.line('$')
      local str = string.format('line: %d\ncol: %d\ntotal: %d', line, col, total)
      vim.notify(str, vim.log.levels.INFO, { title = 'Location', icon = '' })
   end,
   padding = 0,
   separator = { left = '', right = '' },
   color = { gui = 'bold' },
}

local layout = {
   lualine_a = { mode },
   lualine_b = { filename, branch, diff },
   lualine_c = { info, diagnostics },
   lualine_x = { copilot, treesitter, fmt, lsp, fileformat },
   lualine_y = { filesize, filetype },
   lualine_z = { location },
}

local no_layout = {
   lualine_a = {},
   lualine_b = {},
   lualine_c = {},
   lualine_x = {},
   lualine_y = {},
   lualine_z = {},
}

lualine.setup({
   sections = layout,
   inactive_sections = no_layout,
   options = {
      icons_enabled = true,
      globalstatus = true,
      omponent_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { 'alpha', 'dashboard', 'Outline' },
      always_divide_middle = true,
      theme = 'auto',
   },
})
