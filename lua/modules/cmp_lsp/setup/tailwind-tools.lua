local M = {}

---@type TailwindTools.Option|{}
M.opts = {
   server = {
      override = false, -- setup the server from the plugin if true
   },
   document_color = {
      enabled = true, -- can be toggled by commands
      kind = 'inline', -- "inline" | "foreground" | "background"
      inline_symbol = '󰝤 ', -- only used in inline mode
      debounce = 200, -- in milliseconds, only applied in insert mode
   },
   conceal = {
      enabled = false, -- can be toggled by commands
      min_length = nil, -- only conceal classes exceeding the provided length
      symbol = '󱏿', -- only a single character is allowed
      highlight = { -- extmark highlight options, see :h 'highlight'
         fg = '#38BDF8',
      },
   },
   cmp = {
      highlight = 'foreground', -- color preview style, "foreground" | "background"
   },
   -- see the extension section to learn more
   extension = {
      queries = {}, -- a list of filetypes having custom `class` queries
      patterns = { -- a map of filetypes to Lua pattern lists
         -- example:
         rust = { 'class=["\']([^"\']+)["\']' },
         javascript = { 'clsx%(([^)]+)%)' },
         typescript = { 'clsx%(([^)]+)%)' },
         javascriptreact = { 'clsx%(([^)]+)%)' },
         typescriptreact = { 'clsx%(([^)]+)%)' },
      },
   },
}

M.config = function(_, opts)
   local tailwindcss = require('tailwind-tools')

   local lspconfig = require('lspconfig')
   require('telescope').load_extension('tailwind')
   lspconfig.tailwindcss.setup(require('modules.cmp_lsp.lsp.servers.tailwindcss'))
   tailwindcss.setup(opts)
end

return M
