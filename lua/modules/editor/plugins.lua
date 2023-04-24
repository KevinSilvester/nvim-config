-- local plugin = require('core.pack').register_plugin

-- -- hightlight selection

-- -- comments

-- -- navigation

-- -- find + search + replace

-- -- project management
-- plugin({
--    'rmagatti/auto-session',
--    opt = true,
--    cmd = { 'SaveSession', 'RestoreSession', 'DeleteSession' },
--    config = conf.auto_session,
-- })
-- plugin({
--    'ahmedkhalf/project.nvim',
--    opt = true,
--    event = 'BufWinEnter',
--    config = conf.project,
-- })



-- -- misc

return {

   -- hightlight selection
   {
      'RRethy/vim-illuminate',
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.editor.setup.illuminate').opts,
      config = require('modules.editor.setup.illuminate').config,
      keys = require('modules.editor.setup.illuminate').keys,
   },

   -- buffer remove
   {
      'echasnovski/mini.bufremove',
      -- stylua: ignore
      keys = {
         { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
         { "<leader>Q", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
      },
   },

   -- git
   {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = require('modules.editor.setup.gitsigns').opts,
   },
   {
      'sindrets/diffview.nvim',
      dependencies = 'nvim-lua/plenary.nvim',
      cmd = {
         'DiffviewOpen',
         'DiffviewClose',
         'DiffviewRefresh',
         'DiffviewLog',
         'DiffviewFileHistory',
         'DiffviewFocusFiles',
         'DiffviewToggleFiles',
      },
      opts = require('modules.editor.setup.diffview').opts,
   },

   -- minimap
   {
      'wfxr/minimap.vim',
      init = require('modules.editor.setup.minimap').init,
      cmd = {
         'Minimap',
         'MinimapClose',
         'MinimapToggle',
         'MinimapRescan',
         'MinimapRefresh',
         'MinimapUpdateHighlight',
      },
   },

   -- multiple cursors
   {
      'mg979/vim-visual-multi',
      event = 'VeryLazy',
   },

   -- navigation
   {
      'karb94/neoscroll.nvim',
      event = 'VeryLazy',
      opts = require('modules.editor.setup.neoscroll').opts,
   },
   {
      'max397574/better-escape.nvim',
      event = 'InsertEnter',
      opts = require('modules.editor.setup.better-escape').opts,
   },
   {
      'rainbowhxch/accelerated-jk.nvim',
      event = 'VeryLazy',
      opts = require('modules.editor.setup.accelerated-jk').opts,
      keys = {
         { 'j', '<Plug>(accelerated_jk_gj)', mode = { 'n' } },
         { 'k', '<Plug>(accelerated_jk_gk)', mode = { 'n' } },
      },
   },
   {
      'ggandor/flit.nvim',
      keys = function()
         ---@type LazyKeys[]
         local ret = {}
         for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
            ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
         end
         return ret
      end,
      opts = { labeled_modes = 'nx' },
   },
   {
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
         { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
      },
      config = function(_, opts)
         local leap = require('leap')
         for k, v in pairs(opts) do
            leap.opts[k] = v
         end
         leap.add_default_mappings(true)
         vim.keymap.del({ 'x', 'o' }, 'x')
         vim.keymap.del({ 'x', 'o' }, 'X')
      end,
   },
   {
      'edluffy/specs.nvim',
      event = 'CursorMoved',
      config = require('modules.editor.setup.specs').config,
   },

   -- syntax hightlighting
   {
      'nvim-treesitter/nvim-treesitter',
      version = false,
      opts = require('modules.editor.setup.nvim-treesitter').opts,
      init = require('modules.editor.setup.nvim-treesitter').init,
      config = require('modules.editor.setup.nvim-treesitter').config,
      build = ':TSUpdate',
      event = { 'BufReadPost', 'BufNewFile' },
      dependencies = {
         'nvim-treesitter/nvim-treesitter-textobjects',
         'windwp/nvim-ts-autotag',
         'JoosepAlviste/nvim-ts-context-commentstring',
      },
   },
   {
      'nvim-treesitter/nvim-treesitter-textobjects',
      init = function()
         local plugin = require('lazy.core.config').spec.plugins['nvim-treesitter']
         local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
         local enabled = false
         if opts.textobjects then
            for _, mod in ipairs({ 'move', 'select', 'swap', 'lsp_interop' }) do
               if opts.textobjects[mod] and opts.textobjects[mod].enable then
                  enabled = true
                  break
               end
            end
         end
         if not enabled then
            require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
         end
      end,
   },
   {
      'andymass/vim-matchup',
      dependencies = 'nvim-treesitter/nvim-treesitter',
      init = function()
         vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      end,
   },
   {
      'Wansmer/treesj',
      keys = { '<space>m', '<space>j', '<space>s' },
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
         require('treesj').setup({ max_join_length = 480 })
      end,
   },

   -- comments
   {
      'numToStr/Comment.nvim',
      config = require('modules.editor.setup.comment').config,
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      event = 'VeryLazy',
      keys = {
         {
            '<leader>//',
            function()
               require('Comment.api').toggle.linewise.current()
            end,
            mode = { 'n' },
            desc = 'Comment linewise',
         },
         {
            '<leader>/b',
            function()
               require('Comment.api').toggle.blockwise.current()
            end,
            mode = { 'n' },
            desc = 'Comment blockwise',
         },
      },
   },
   {
      'folke/todo-comments.nvim',
      cmd = { 'TodoTrouble', 'TodoTelescope' },
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.editor.setup.todo-comments').opts,
      keys = require('modules.editor.setup.todo-comments').keys,
      config = true,
   },

   -- misc
   {
      'abecodes/tabout.nvim',
      event = 'InsertEnter',
      opts = require('modules.editor.setup.tabout').opts,
      keys = {
         { '<A-l', modes = { 'n' } },
         { '<A-h', modes = { 'n' } },
      },
   },
}
