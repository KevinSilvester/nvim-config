local hl = require('utils.colours').get_hl
local M = {}

M.opts = {
   attach_navic = false,
   create_autocmd = true,
   include_buftypes = { '' },
   exclude_filetypes = { 'netrw', 'toggleterm', 'lazy', 'alpha', 'NvimTree' },
   modifiers = {
      dirname = ':~:.',
      basename = '',
   },
   show_dirname = true,
   show_basename = true,
   show_modified = true,
   modified = function(bufnr)
      return vim.bo[bufnr].modified
   end,
   show_navic = true,
   context_follow_icon_color = true,
   symbols = {
      modified = '●',
      ellipsis = '…',
      separator = '',
   },
   kinds = require('modules.ui.icons').kind,
   theme = 'auto',
}

M.config = function(_, opts)
   -- stylua: ignore
   -- opts.theme = {
   -- normal                 = { bg = hl('Normal').bg, fg = hl('Normal').fg },
   -- ellipsis               = { fg = hl('Conceal').fg },
   -- separator              = { fg = hl('Error').fg },
   -- modified               = { fg = hl('GitSignsChange').fg },
   -- dirname                = { fg = hl('Conceal').fg },
   -- basename               = { bold = true },
   -- context                = {},
   -- context_array          = { fg = hl('Structure').fg },
   -- context_boolean        = { fg = hl('Boolean').fg },
   -- context_class          = { fg = hl('Include').fg },
   -- context_constant       = { fg = hl('Constant').fg },
   -- context_constructor    = { fg = hl('@constructor').fg },
   -- context_enum           = { fg = hl('@number').fg },
   -- context_enum_member    = { fg = hl('Identifier').fg },
   -- context_event          = { fg = hl('Constant').fg },
   -- context_field          = { fg = hl('@field').fg },
   -- context_file           = { fg = hl('Tag').fg },
   -- context_function       = { fg = hl('Function').fg },
   -- context_interface      = { fg = hl('Type').fg },
   -- context_key            = { fg = hl('Identifier').fg },
   -- context_method         = { fg = hl('Function').fg },
   -- context_module         = { fg = hl('Exception').fg },
   -- context_null           = { fg = hl('Special').fg },
   -- context_namespace      = { fg = hl('Include').fg },
   -- context_number         = { fg = hl('Number').fg },
   -- context_object         = { fg = hl('Structure').fg },
   -- context_operator       = { fg = hl('Operator').fg },
   -- context_package        = { fg = hl('Label').fg },
   -- context_property       = { fg = hl('@property').fg },
   -- context_string         = { fg = hl('String').fg },
   -- context_struct         = { fg = hl('Structure').fg },
   -- context_type_parameter = { fg = hl('Type').fg },
   -- context_variable       = { fg = hl('@variable').fg },
   -- }

   -- vim.api.nvim_create_autocmd({
   --    'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
   --    'BufWinEnter',
   --    'CursorHold',
   --    'InsertLeave',
   --    'BufModifiedSet',
   -- }, {
   --    group = vim.api.nvim_create_augroup('barbecue.updater', {}),
   --    callback = function()
   --       require('barbecue.ui').update()
   --    end,
   -- })
   require('barbecue').setup(opts)
end

return M
