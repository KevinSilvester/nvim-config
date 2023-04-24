-- local bufferline = require('bufferline')

return {
   options = {
          always_show_bufferline = true,
      mode = 'buffers',
      numbers = 'none',
      close_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
      right_mouse_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
      separator_style = 'thin', -- | "thick" | "thin" | { 'any', 'any' },
      show_tab_indicators = true,
      -- diagnostics = 'nvim_lsp',
      -- diagnostics_indicator = function(_, _, diag)
      --    local icons = require('modules.ui.icons').diagnostics
      --    local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
      --       .. (diag.warning and icons.Warn .. diag.warning or '')
      --    return vim.trim(ret)
      -- end,
      offsets = {
         {
            filetype = 'neo-tree',
            highlight = 'Directory',
            text_align = 'left',
         },
         {
            filetype = 'NvimTree',
            highlight = 'Directory',
            text_align = 'left',
         },
      },
   },
   highlights = {
      -- fill = {
      --    fg = { attribute = 'fg', highlight = '#ff0000' },
      --    bg = { attribute = 'bg', highlight = 'TabLine' },
      -- },
      background = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      buffer_visible = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      close_button = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      close_button_visible = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      tab_selected = {
         fg = { attribute = 'fg', highlight = 'Normal' },
         bg = { attribute = 'bg', highlight = 'Normal' },
      },
      tab = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      tab_close = {
         fg = { attribute = 'fg', highlight = 'TabLineSel' },
         bg = { attribute = 'bg', highlight = 'Normal' },
      },
      duplicate_selected = {
         fg = { attribute = 'fg', highlight = 'TabLineSel' },
         bg = { attribute = 'bg', highlight = 'TabLineSel' },
         italic = true,
      },
      duplicate_visible = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
         italic = true,
      },
      duplicate = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
         italic = true,
      },
      modified = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      modified_selected = {
         fg = { attribute = 'fg', highlight = 'Normal' },
         bg = { attribute = 'bg', highlight = 'Normal' },
      },
      modified_visible = {
         fg = { attribute = 'fg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      separator = {
         fg = { attribute = 'bg', highlight = 'TabLine' },
         bg = { attribute = 'bg', highlight = 'TabLine' },
      },
      separator_selected = {
         fg = { attribute = 'bg', highlight = 'Normal' },
         bg = { attribute = 'bg', highlight = 'Normal' },
      },
      indicator_selected = {
         fg = { attribute = 'fg', highlight = 'LspDiagnosticsDefaultHint' },
         bg = { attribute = 'bg', highlight = 'Normal' },
      },
   },
}
