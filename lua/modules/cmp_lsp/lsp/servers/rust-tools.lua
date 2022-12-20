return {
   tools = {
      executor = require('rust-tools.executors').termopen,
      -- autoSetHints = false,
      on_initialized = function()
         vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            pattern = { '*.rs' },
            callback = function()
               vim.lsp.codelens.refresh()
            end,
         })
      end,

      inlay_hints = {
         -- automatically set inlay hints (type hints)
         -- default: true
         auto = true,

         -- Only show inlay hints for the current line
         only_current_line = false,

         -- whether to show parameter hints with the inlay hints or not
         -- default: true
         show_parameter_hints = true,

         -- prefix for parameter hints
         -- default: "<-"
         parameter_hints_prefix = '<- ',

         -- prefix for all the other hints (type, chaining)
         -- default: "=>"
         other_hints_prefix = '=> ',

         -- whether to align to the lenght of the longest line in the file
         max_len_align = false,

         -- padding from the left if max_len_align is true
         max_len_align_padding = 1,

         -- whether to align to the extreme right or not
         right_align = false,

         -- padding from the right if right_align is true
         right_align_padding = 7,

         -- The color of the hints
         highlight = 'Comment',
      },
      hover_actions = {
         auto_focus = false,
         border = {
            { '╭', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╮', 'FloatBorder' },
            { '│', 'FloatBorder' },
            { '╯', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╰', 'FloatBorder' },
            { '│', 'FloatBorder' },
         },
      },
   },
   server = {
      cmd = { 'rust-analyzer' },
      on_attach = require('modules.cmp_lsp.lsp.setup').on_attach,
      capabilities = require('modules.cmp_lsp.lsp.setup').capabilities,
      settings = {
         ['rust-analyzer'] = {
            lens = { enable = true },
            checkOnSave = { command = 'clippy' },
            procMacro = { enable = true },
            diagnostics = { disabled = { 'unresolved-proc-macro' } },
         },
      },
   },
   dap = {
      adapter = {
         type = 'executable',
         command = 'lldb-vscode',
         name = 'rt_lldb',
      },
   },
}
