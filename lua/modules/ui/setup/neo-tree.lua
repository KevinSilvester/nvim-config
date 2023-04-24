local M = {}

M.init = function()
   vim.g.neo_tree_remove_legacy_commands = 1
   if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
         require('neo-tree')
      end
   end
end

-- M.opts = {
--    filesystem = {
--       bind_to_cwd = false,
--       follow_current_file = true,
--    },
--    window = {
--       mappings = {
--          ['<space>'] = 'none',
--       },
--    },
--    default_component_configs = {
--       indent = {
--          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
--          expander_collapsed = '',
--          expander_expanded = '',
--          expander_highlight = 'NeoTreeExpander',
--       },
--    },
-- }

M.opts = {
   close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
   popup_border_style = 'rounded',
   enable_git_status = true,
   enable_diagnostics = true,
   open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
   sort_case_insensitive = false, -- used when sorting files and directories in the tree
   sort_function = nil, -- use a custom function for sorting files and directories in the tree
   default_component_configs = {
      container = {
         enable_character_fade = true,
      },
      indent = {
         indent_size = 2,
         padding = 1,
         with_markers = true,
         indent_marker = '│',
         last_indent_marker = '╰',
         highlight = 'NeoTreeIndentMarker',
         with_expanders = '├', -- if nil and file nesting is enabled, will enable expanders
         expander_collapsed = '',
         expander_expanded = '',
         expander_highlight = 'NeoTreeExpander',
      },
      diagnostics = {
         symbols = {
            hint = '',
            info = '',
            warning = '',
            error = '',
         },
         highlights = {
            hint = 'DiagnosticSignHint',
            info = 'DiagnosticSignInfo',
            warn = 'DiagnosticSignWarn',
            error = 'DiagnosticSignError',
         },
      },
      icon = {
         folder_closed = '',
         folder_open = '',
         folder_empty = '',
         folder_empty_open = '',
         default = '',
         highlight = 'NeoTreeFileIcon',
      },
      modified = {
         symbol = '[+]',
         highlight = 'NeoTreeModified',
      },
      name = {
         trailing_slash = false,
         use_git_status_colors = true,
         highlight = 'NeoTreeFileName',
      },
      git_status = {
         symbols = {
            added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '', -- this can only be used in the git_status source
            renamed = '', -- this can only be used in the git_status source
            untracked = 'U',
            ignored = '◌',
            unstaged = '',
            staged = 'S',
            conflict = '',
         },
      },
   },
   -- A list of functions, each representing a global custom command
   -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
   -- see `:h neo-tree-global-custom-commands`
   commands = {},
   window = {
      position = 'left',
      width = 40,
      mapping_options = {
         noremap = true,
         nowait = true,
      },
      mappings = {
         ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
         },
         ['<2-LeftMouse>'] = 'open',
         ['<cr>'] = 'open',
         ['<esc>'] = 'revert_preview',
         ['P'] = { 'toggle_preview', config = { use_float = true } },
         ['l'] = 'focus_preview',
         ['S'] = 'open_split',
         ['s'] = 'open_vsplit',
         -- ["S"] = "split_with_window_picker",
         -- ["s"] = "vsplit_with_window_picker",
         ['t'] = 'open_tabnew',
         -- ["<cr>"] = "open_drop",
         -- ["t"] = "open_tab_drop",
         ['w'] = 'open_with_window_picker',
         --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
         ['C'] = 'close_node',
         -- ['C'] = 'close_all_subnodes',
         ['z'] = 'close_all_nodes',
         --["Z"] = "expand_all_nodes",
         ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
               show_path = 'none', -- "none", "relative", "absolute"
            },
         },
         ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
         ['d'] = 'delete',
         ['r'] = 'rename',
         ['y'] = 'copy_to_clipboard',
         ['x'] = 'cut_to_clipboard',
         ['p'] = 'paste_from_clipboard',
         ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
         -- ["c"] = {
         --  "copy",
         --  config = {
         --    show_path = "none" -- "none", "relative", "absolute"
         --  }
         --}
         ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
         ['q'] = 'close_window',
         ['R'] = 'refresh',
         ['?'] = 'show_help',
         ['<'] = 'prev_source',
         ['>'] = 'next_source',
      },
   },
   nesting_rules = {},
   filesystem = {
      filtered_items = {
         visible = true, -- when true, they will just be displayed differently than normal items
         hide_dotfiles = false,
         hide_gitignored = false,
         hide_hidden = false, -- only works on Windows for hidden files/directories
         hide_by_name = {
            '.DS_Store',
            'thumbs.db',
         },
         hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
         },
         always_show = { -- remains visible even if other settings would normally hide it
            '.gitignored',
         },
         never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            '.DS_Store',
            'thumbs.db',
         },
         never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
         },
      },
      follow_current_file = true, -- This will find and focus the file in the active buffer every
      bind_to_cwd = false,
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = 'open_default',
      use_libuv_file_watcher = true,
      window = {
         mappings = {
            ['<space>'] = 'none',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ['f'] = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
         },
         fuzzy_finder_mappings = {
            -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
         },
      },
      default_component_configs = {
         indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
         },
      },
      commands = {}, -- Add a custom command or override a global one using the same function name
   },
   buffers = {
      follow_current_file = true, -- This will find and focus the file in the active buffer every
      -- time the current file is changed while the tree is open.
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
         mappings = {
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
         },
      },
   },
   git_status = {
      window = {
         position = 'float',
         mappings = {
            ['A'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['ga'] = 'git_add_file',
            ['gr'] = 'git_revert_file',
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
         },
      },
   },
}

M.keys = {
   {
      '<leader>fe',
      function()
         require('neo-tree.command').execute({ toggle = true, dir = require('utils.fn').get_root() })
      end,
      desc = 'Explorer NeoTree (root dir)',
   },
   {
      '<leader>fE',
      function()
         require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = 'Explorer NeoTree (cwd)',
   },
   { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
   { '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
}

return M
