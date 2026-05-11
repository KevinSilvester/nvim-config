local M = {}

M.opts = {
   lsp = {
      override = {
         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
         ['vim.lsp.util.stylize_markdown'] = true,
         ['cmp.entry.get_documentation'] = true,
      },
      hover = { enabled = false },
      progress = { enabled = false },
      signature = { enabled = false },
   },
   presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = false,
   },
   cmdline = {
      view = 'cmdline_popup', ---@type 'cmdline'|'cmdline_popup'
   },
   popupmenu = {
      enabled = true,
      backend = 'nui', ---@type 'nui'|'cmp'
   },
}

--stylua: ignore
M.keys = {
   {
      '<S-Enter>',
      function() require('noice').redirect(vim.fn.getcmdline()) end,
      mode = 'c',
      desc =
      'Redirect Cmdline',
   },
   { '<leader>snl', function() require('noice').cmd('last') end,    desc = 'Noice Last Message', },
   { '<leader>sna', function() require('noice').cmd('all') end,     desc = 'Noice All', },
   { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All', },
}

return M
