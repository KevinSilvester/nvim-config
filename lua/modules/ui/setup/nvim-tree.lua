local M = {}
local icons = require('modules.ui.icons')

M.opts = {
   on_attach = 'disable',
   view = {
      adaptive_size = false,
      width = 40,
   },
   renderer = {
      highlight_git = true,
      highlight_opened_files = 'none',
      -- root_folder_label = ':t',
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
         symlink_arrow = ' -> ',
         git_placement = 'before',
         glyphs = {
            default = icons.fs.File,
            symlink = icons.fs.FileSymlink,
            bookmark = icons.fs.BookMark,
            folder = {
               arrow_closed = '',
               arrow_open = '',
               default = icons.fs.DirClosed,
               open = icons.fs.DirOpen,
               empty = icons.fs.DirEmptyClosed,
               empty_open = icons.fs.DirEmptyOpen,
               symlink = icons.fs.DirSymlink,
               symlink_open = icons.fs.DirOpen,
            },
            git = {
               unstaged = icons.git.Unstaged,
               staged = icons.git.Staged,
               unmerged = icons.git.Unmerged,
               renamed = icons.git.Rename,
               untracked = icons.git.Untracked,
               deleted = icons.git.Remove,
               ignored = icons.git.Ignore,
               -- ignored = "◌",
            },
         },
      },
      special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md', 'package.json' },
   },
   hijack_directories = {
      enable = false, -- true
      auto_open = true,
   },
   update_focused_file = {
      enable = true, -- false
      debounce_delay = 15, -- missing
      update_root = true, -- false
      update_cwd = true,
   },
   diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
      icons = {
         hint = icons.diagnostics.Hint,
         info = icons.diagnostics.Info,
         warning = icons.diagnostics.Warning,
         error = icons.diagnostics.Error,
      },
   },
   filters = {
      custom = { 'node_modules', '\\.cache', '^.git$', 'target', '\\.idea' }, -- {}
   },
   live_filter = {
      prefix = '[FILTER]: ',
      always_show_folders = false,
   },
   git = {
      enable = true,
      ignore = false,
      show_on_dirs = true,
      show_on_open_dirs = true,
      timeout = 200, -- 400
   },
   actions = {
      file_popup = {
         open_win_config = {
            border = 'rounded', -- rounded
         },
      },
      open_file = {
         resize_window = false, -- true
         window_picker = {
            exclude = {
               filetype = { 'notify', 'lazy', 'lir', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
               buftype = { 'nofile', 'terminal', 'help' },
            },
         },
      },
   },
   trash = {
      cmd = HOST.is_win and 'Remove-ItemSafely' or 'trash-put', -- 'gio trash'
      require_confirm = true, -- missing
   },
   experimental = {
      git = { async = true },
   },
}

M.config = function(_, opts)
   local buf_nmap = require('core.mapper').buf_nmap
   local k_opts = require('core.mapper').new_opts
   local silent = require('core.mapper').silent
   local noremap = require('core.mapper').noremap
   local nowait = require('core.mapper').nowait
   local api = require('nvim-tree.api')

   opts.on_attach = function(bufnr)
      api.config.mappings.default_on_attach(bufnr)

      buf_nmap(bufnr, {
         -- { 'A', api.tree.expand_all, k_opts(silent, noremap, nowait, 'Expand All') },
         { 'h', api.node.navigate.parent_close, k_opts(silent, noremap, nowait, 'Close') },
         { 'H', api.tree.collapse_all, k_opts(silent, noremap, nowait, 'Collapse All') },
         { '?', api.tree.toggle_help, k_opts(silent, noremap, nowait, 'Help') },
         { 't', api.tree.toggle_custom_filter, k_opts(silent, noremap, nowait, 'Toggle Filter') },
         { 'C', api.tree.change_root_to_node, k_opts(silent, noremap, nowait, 'CD') },
         {
            'P',
            function()
               require('utils.fn').inspect(api.tree.get_node_under_cursor())
            end,
            k_opts(silent, noremap, nowait, 'Print Node Path'),
         },
         { 'Z', api.node.run.system, k_opts(silent, noremap, nowait, 'Run System') },
         {
            'l',
            api.node.open.edit,
            k_opts(silent, noremap, nowait, 'Edit Or Open'),
         },
         {
            'L',
            function()
               local node = api.tree.get_node_under_cursor()
               if node ~= nil and node.nodes ~= nil then
                  api.node.open.edit()
               else
                  api.node.open.preview()
               end
               api.tree.focus()
            end,
            k_opts(silent, noremap, nowait, 'Vsplit Preview'),
         },
      })
   end

   require('nvim-tree').setup(opts)
end

M.init = function() end

return M
