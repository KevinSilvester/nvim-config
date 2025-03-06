local icons = require('modules.ui.icons').diagnostics

--  setup diagnostics signs
local custom_diagnostics_signs = {
   { name = 'DiagnosticSignError', text = icons.Error },
   { name = 'DiagnosticSignWarn', text = icons.Warning },
   { name = 'DiagnosticSignHint', text = icons.Hint },
   { name = 'DiagnosticSignInfo', text = icons.Info },
}
for _, sign in ipairs(custom_diagnostics_signs) do
   vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local severity_map = {
   [vim.lsp.protocol.DiagnosticSeverity.Error] = 'Error',
   [vim.lsp.protocol.DiagnosticSeverity.Warning] = 'Warn',
   [vim.lsp.protocol.DiagnosticSeverity.Hint] = 'Hint',
   [vim.lsp.protocol.DiagnosticSeverity.Information] = 'Info',
}

vim.diagnostic.config({
   virtual_text = false, -- will be handled by tiny-inline-diagnostic.nvim
   signs = { active = custom_diagnostics_signs }, -- show signs
   update_in_insert = true,
   underline = true,
   severity_sort = true,
   float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = true,
      header = ' ' .. vim.fn.expand('%:t'),
      prefix = function(diagnostic, _idx, _total)
         -- log:debug('diagnostic', diagnostic, true)
         local icon_highlight = 'DiagnosticSign' .. severity_map[diagnostic.severity]
         local icon_text = '  '
         return icon_text, icon_highlight
      end,
   },
})
