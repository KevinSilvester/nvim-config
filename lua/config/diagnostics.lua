local icons = require('modules.ui.icons').diagnostics

local severity_map = {
   [vim.lsp.protocol.DiagnosticSeverity.Error] = 'Error',
   [vim.lsp.protocol.DiagnosticSeverity.Warning] = 'Warn',
   [vim.lsp.protocol.DiagnosticSeverity.Hint] = 'Hint',
   [vim.lsp.protocol.DiagnosticSeverity.Information] = 'Info',
}

vim.diagnostic.config({
   virtual_text = false, -- will be handled by tiny-inline-diagnostic.nvim
   signs = {
      text = {
         [vim.lsp.protocol.DiagnosticSeverity.Error] = icons.Error,
         [vim.lsp.protocol.DiagnosticSeverity.Warning] = icons.Warning,
         [vim.lsp.protocol.DiagnosticSeverity.Hint] = icons.Hint,
         [vim.lsp.protocol.DiagnosticSeverity.Information] = icons.Info,
      },
      texthl = {
         [vim.lsp.protocol.DiagnosticSeverity.Error] = 'DiagnosticSignError',
         [vim.lsp.protocol.DiagnosticSeverity.Warning] = 'DiagnosticSignWarn',
         [vim.lsp.protocol.DiagnosticSeverity.Hint] = 'DiagnosticSignHint',
         [vim.lsp.protocol.DiagnosticSeverity.Information] = 'DiagnosticSignInfo',
      },
      numhl = {
         [vim.lsp.protocol.DiagnosticSeverity.Error] = '',
         [vim.lsp.protocol.DiagnosticSeverity.Warning] = '',
         [vim.lsp.protocol.DiagnosticSeverity.Hint] = '',
         [vim.lsp.protocol.DiagnosticSeverity.Information] = '',
      },
   },
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
