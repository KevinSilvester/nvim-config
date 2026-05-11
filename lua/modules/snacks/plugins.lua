local layouts = {
   SELECT = { layout = { preset = 'select' } },
   VSCODE = { layout = { preset = 'vscode' } },
   IVY = { layout = { preset = 'ivy', position = 'top' } },
   SELECT_PREVIEW = { layout = { preset = 'select_preview' } },
   VSCODE_PREVIEW = { layout = { preset = 'vscode_preview' } },
}

return {
   'folke/snacks.nvim',
   priority = 1000,
   lazy = false,
   opts = {
      bigfile = { enabled = true },
      dashboard = require('modules.snacks.setup.dashboard'),
      explorer = { enabled = false },
      image = { enabled = true },
      indent = require('modules.snacks.setup.indent'),
      input = require('modules.snacks.setup.input'),
      picker = require('modules.snacks.setup.picker'),
      notifier = require('modules.snacks.setup.notifier'),
      quickfile = { enabled = true },
      scratch = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      zen = require('modules.snacks.setup.zen'),
   },

   -- stylua: ignore
   keys = {

      -- bufdelete
      { '<leader>bd',      function() Snacks.bufdelete.delete({ buf = 0, force = false }) end,                    desc = '[Snacks] Delete Buffer', },
      { '<leader>bD',      function() Snacks.bufdelete.delete({ buf = 0, force = true }) end,                     desc = '[Snacks] Delete Buffer (Force)', },
      { '<leader>bo',      function() Snacks.bufdelete.other({ force = true }) end,                               desc = '[Snacks] Delete Buffer', },
      { '<leader>bO',      function() Snacks.bufdelete.other({ force = true }) end,                               desc = '[Snacks] Delete Buffer (Force) ', },


      -- Top Pickers & Explorer
      { '<leader><space>', function() Snacks.picker.smart() end,                                                  desc = '[Snacks] Smart Find Files' },

      -- find
      { '<leader>fb',      function() Snacks.picker.buffers(layouts.VSCODE_PREVIEW) end,                          desc = '[Snacks] Buffers' },
      { '<leader>fc',      function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end,                desc = '[Snacks] Find Config File' },
      { '<leader>ff',      function() Snacks.picker.files() end,                                                  desc = '[Snacks] Find Files' },
      { '<leader>fg',      function() Snacks.picker.git_files() end,                                              desc = '[Snacks] Find Git Files' },
      { '<leader>fp',      function() Snacks.picker.projects() end,                                               desc = '[Snacks] Projects' },
      { '<leader>fr',      function() Snacks.picker.recent() end,                                                 desc = '[Snacks] Recent' },
      { '<leader>fz',      function() Snacks.picker.zoxide() end,                                                 desc = '[Snacks] Zoxide' },


      -- git
      { '<leader>gb',      function() Snacks.picker.git_branches() end,                                           desc = '[Snacks] Git Branches' },
      { '<leader>gl',      function() Snacks.picker.git_log() end,                                                desc = '[Snacks] Git Log' },
      { '<leader>gL',      function() Snacks.picker.git_log_line() end,                                           desc = '[Snacks] Git Log Line' },
      { '<leader>gS',      function() Snacks.picker.git_status() end,                                             desc = '[Snacks] Git Status' },
      { '<leader>gd',      function() Snacks.picker.git_diff() end,                                               desc = '[Snacks] Git Diff (Hunks)' },
      { '<leader>gf',      function() Snacks.picker.git_log_file() end,                                           desc = '[Snacks] Git Log File' },

      -- image
      { '<leader>ik',      function() Snacks.image.hover() end,                                                   desc = '[Snacks] Hover Image' },

      -- scratch
      { '<leader>So',       function() Snacks.scratch.open() end,                                                 desc = '[Snacks] Scratch Pad Open' },
      { '<leader>Ss',       function() Snacks.scratch.select() end,                                               desc = '[Snacks] Scratch Pad Select' },

      -- Grep
      { '<leader>sb',      function() Snacks.picker.lines() end,                                                  desc = '[Snacks] Buffer Lines' },
      { '<leader>sB',      function() Snacks.picker.grep_buffers() end,                                           desc = '[Snacks] Grep Open Buffers' },
      { '<leader>sg',      function() Snacks.picker.grep() end,                                                   desc = '[Snacks] Grep' },
      { '<leader>sw',      function() Snacks.picker.grep_word() end,                                              desc = '[Snacks] Visual selection or word', mode = { 'n', 'x' } },

      -- search
      { '<leader>s\'',     function() Snacks.picker.registers() end,                                              desc = '[Snacks] Registers' },
      { '<leader>s/',      function() Snacks.picker.search_history() end,                                         desc = '[Snacks] Search History' },
      { '<leader>sa',      function() Snacks.picker.autocmds() end,                                               desc = '[Snacks] Autocmds' },
      { '<leader>sb',      function() Snacks.picker.lines() end,                                                  desc = '[Snacks] Buffer Lines' },
      { '<leader>sc',      function() Snacks.picker.command_history() end,                                        desc = '[Snacks] Command History' },
      { '<leader>sC',      function() Snacks.picker.commands() end,                                               desc = '[Snacks] Commands' },
      { '<leader>sd',      function() Snacks.picker.diagnostics() end,                                            desc = '[Snacks] Diagnostics' },
      { '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end,                                     desc = '[Snacks] Buffer Diagnostics' },
      { '<leader>sh',      function() Snacks.picker.help() end,                                                   desc = '[Snacks] Help Pages', },
      { '<leader>sH',      function() Snacks.picker.highlights() end,                                             desc = '[Snacks] Highlights' },
      { '<leader>si',      function() Snacks.picker.icons(layouts.VSCODE_PREVIEW) end,                            desc = '[Snacks] Icons' },
      { '<leader>sj',      function() Snacks.picker.jumps() end,                                                  desc = '[Snacks] Jumps' },
      { '<leader>sk',      function() Snacks.picker.keymaps() end,                                                desc = '[Snacks] Keymaps' },
      { '<leader>sl',      function() Snacks.picker.loclist() end,                                                desc = '[Snacks] Location List' },
      { '<leader>sm',      function() Snacks.picker.marks() end,                                                  desc = '[Snacks] Marks' },
      { '<leader>sM',      function() Snacks.picker.man() end,                                                    desc = '[Snacks] Man Pages' },
      { '<leader>sN',      function() Snacks.picker.notifications() end,                                          desc = '[Snacks] Notification History' },
      { '<leader>sp',      function() Snacks.picker.lazy() end,                                                   desc = '[Snacks] Search for Plugin Spec' },
      { '<leader>sq',      function() Snacks.picker.qflist() end,                                                 desc = '[Snacks] Quickfix List' },
      { '<leader>sR',      function() Snacks.picker.resume() end,                                                 desc = '[Snacks] Resume' },
      { '<leader>sU',      function() Snacks.picker.colorschemes() end,                                           desc = '[Snacks] Colorschemes' },
      { '<leader>su',      function() Snacks.picker.undo() end,                                                   desc = '[Snacks] Undo History' },
      { '<leader>sy',      function() Snacks.picker.yanky() end,                                                  desc = '[Snacks] Yanky History' },

      -- LSP
      { 'gd',              function() Snacks.picker.lsp_definitions() end,                                        desc = '[Snacks] Goto Definition' },
      { 'gD',              function() Snacks.picker.lsp_declarations() end,                                       desc = '[Snacks] Goto Declaration' },
      { 'gr',              function() Snacks.picker.lsp_references() end,                                         desc = '[Snacks] References',               nowait = true, },
      { 'gI',              function() Snacks.picker.lsp_implementations() end,                                    desc = '[Snacks] Goto Implementation' },
      { 'gy',              function() Snacks.picker.lsp_type_definitions() end,                                   desc = '[Snacks] Goto T[y]pe Definition' },

      -- jump to reference
      { ']r',              function() Snacks.words.jump(vim.v.count1) end,                                        desc = '[Snacks] Next Reference',           mode = { 'n', 't' } },
      { '[r',              function() Snacks.words.jump(-vim.v.count1) end,                                       desc = '[Snacks] Prev Reference',           mode = { 'n', 't' } },

      -- rename
      { '<leader>R',       function() Snacks.rename.rename_file() end,                                            desc = '[Snacks] Rename file' },

      -- noice
      ---@diagnostic disable-next-line: undefined-field
      { '<leader>snh',     function() Snacks.picker.noice() end,                                                  desc = '[Snacks] Noice History', },

      -- todo-comments: exported by todo-comments.nvim
      { '<leader>st',      function() Snacks.picker.todo_comments() end,                                          desc = '[Snacks] Todo' },
      { '<leader>sT',      function() Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } }) end, desc = '[Snacks] Todo/Fix/Fixme' },

      -- zen mode
      { '<leader>zz',      function() Snacks.zen.zen() end,                                                       desc = '[Snacks] Zen Mode' },
      { '<leader>zZ',      function() Snacks.zen.zoom() end,                                                      desc = '[Snacks] Zen Mode' },
   },
}
