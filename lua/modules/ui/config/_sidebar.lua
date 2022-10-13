local nvim_tree = require('nvim-tree')
local tree_cb = require('nvim-tree.config').nvim_tree_callback

nvim_tree.setup({
   update_focused_file = {
      enable = true,
      update_cwd = true,
   },
   renderer = {
      root_folder_modifier = ':t',
      indent_markers = {
         enable = true,
         icons = {
            corner = '╰',
            edge = '│ ',
            item = '├ ',
            none = '  ',
         },
      },
      icons = {
         show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = true,
         },
         glyphs = {
            default = '',
            symlink = '',
            folder = {
               arrow_open = '',
               arrow_closed = '',
               default = '',
               open = '',
               empty = '',
               empty_open = '',
               symlink = '',
               symlink_open = '',
            },
            git = {
               unstaged = '',
               staged = 'S',
               unmerged = '',
               renamed = '➜',
               untracked = 'U',
               deleted = '',
               ignored = '◌',
            },
         },
      },
   },
   diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
         hint = '',
         info = '',
         warning = '',
         error = '',
      },
   },
   view = {
      width = 30,
      side = 'left',
      mappings = {
         list = {
            { key = { 'l', '<CR>', 'o' }, cb = tree_cb('edit') },
            { key = 'h', cb = tree_cb('close_node') },
            { key = 'v', cb = tree_cb('vsplit') },
         },
      },
   },
})
