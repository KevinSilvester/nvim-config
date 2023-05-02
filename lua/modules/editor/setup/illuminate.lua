local m = require('core.mapper')
local M = {}

M.opts = {
   providers = { 'lsp', 'treesitter', 'regex' },
   delay = 200,
   filetypes_denylist = {
      'dirvish',
      'fugitive',
      'alpha',
      'NvimTree',
      'lazy',
      'neogitstatus',
      'Trouble',
      'lir',
      'Outline',
      'spectre_panel',
      'toggleterm',
      'DressingSelect',
      'TelescopePrompt',
   },
}

M.config = function(_, opts)
   require('illuminate').configure(opts)

   vim.api.nvim_create_autocmd('FileType', {
      callback = function()
         m.buf_nmap(vim.api.nvim_get_current_buf(), {
            {
               '[r',
               function()
                  require('illuminate').goto_prev_reference(true)
               end,
               m.opts(m.silent, m.noremap, 'Goto previous reference'),
            },
            {
               ']r',
               function()
                  require('illuminate').goto_next_reference(true)
               end,
               m.opts(m.silent, m.noremap, 'Goto next reference'),
            },
         })
      end,
   })
end

M.keys = {
   {
      '[r',
      function()
         require('illuminate').goto_prev_reference(true)
      end,
      desc = 'Goto previous reference',
   },
   {
      ']r',
      function()
         require('illuminate').goto_next_reference(true)
      end,
      desc = 'Goto next reference',
   },
}

return M
