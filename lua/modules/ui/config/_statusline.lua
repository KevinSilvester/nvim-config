local lualine = require('lualine')

local diagnostics = {
   'diagnostics',
   sources = { 'nvim_diagnostic' },
   sections = { 'error', 'warn' },
   symbols = { error = ' ', warn = ' ' },
   colored = true,
   update_in_insert = false,
   always_visible = true,
}

local diff = {
   'diff',
   source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
         return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
         }
      end
   end,
   symbols = { added = ' ', modified = ' ', removed = ' ' },
   diff_color = {
      added = { fg = '#98be65' },
      modified = { fg = '#ec5f67' },
      removed = { fg = '#ECBE7B' },
   },
}

local mode = {
   'mode',
   fmt = function(str)
      return str
   end,
}

local filetype = {
   'filetype',
   icons_enabled = false,
   icon = nil,
}

local branch = {
   'branch',
   icons_enabled = true,
   icon = '',
}

local treesitter = {
   function()
      return ''
   end,
   color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and '#98be65' or '#ECBE7B' }
   end,
}

-- cool function for progress
local progress = {
   'progress',
   fmt = function(str)
      return '%l/%L'
   end,
   icons_enabled = true,
   color = { gui = 'bold' },
   icon = '',
}

lualine.setup({
   options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { 'alpha', 'dashboard' },
      always_divide_middle = true,
   },
   sections = {
      lualine_a = { mode },
      lualine_b = { branch, 'filename' },
      lualine_c = { diff, diagnostics },
      lualine_x = { treesitter },
      lualine_y = { 'encoding', filetype },
      lualine_z = { progress },
   },
   inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
   },
   tabline = {},
   extensions = {},
})
