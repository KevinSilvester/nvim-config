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
         { '<leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete Buffer', },
         { '<leader>bD', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete Buffer (Force)', },
      },
   },

   -- minimap
   {
      'echasnovski/mini.map',
      config = require('modules.editor.setup.mini-map').config,
      keys = require('modules.editor.setup.mini-map').keys,
   },
   -- {
   --    'wfxr/minimap.vim',
   --    init = require('modules.editor.setup.minimap').init,
   --    cmd = {
   --       'Minimap',
   --       'MinimapClose',
   --       'MinimapToggle',
   --       'MinimapRescan',
   --       'MinimapRefresh',
   --       'MinimapUpdateHighlight',
   --    },
   -- },

   -- git
   {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = require('modules.editor.setup.gitsigns').opts,
      keys = require('modules.editor.setup.gitsigns').keys,
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
      keys = require('modules.editor.setup.diffview').keys,
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
   {
      'gbprod/stay-in-place.nvim',
      event = 'VeryLazy',
      config = true,
   },
   {
      'nacro90/numb.nvim',
      event = 'CmdlineEnter',
      config = true,
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
         'nvim-treesitter/nvim-treesitter-refactor',
         'nvim-treesitter/nvim-treesitter-context',
         'windwp/nvim-ts-autotag',
         'JoosepAlviste/nvim-ts-context-commentstring',
         'andymass/vim-matchup',
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
      'nvim-treesitter/nvim-treesitter-context',
      init = function()
         local plugin = require('lazy.core.config').spec.plugins['nvim-treesitter']
         local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
         local enabled = false
         if opts.context then
            if opts.context and opts.context.enable then
               enabled = true
            end
         end
         if not enabled then
            require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-context')
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
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
         require('treesj').setup({ max_join_length = 480 })
      end,
      -- stylua: ignore
      keys = {
         { '<leader>jt', function() require('treesj').toggle() end, desc = 'Toggle split/join block', },
         { '<leader>jj', function() require('treesj').join() end,   desc = 'Join block', },
         { '<leader>js', function() require('treesj').split() end,  desc = 'Split block', },
      },
   },

   -- comments
   {
      'numToStr/Comment.nvim',
      config = require('modules.editor.setup.comment').config,
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      event = 'VeryLazy',
   },
   {
      'folke/todo-comments.nvim',
      cmd = { 'TodoTrouble', 'TodoTelescope' },
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.editor.setup.todo-comments').opts,
      keys = require('modules.editor.setup.todo-comments').keys,
      config = true,
   },

   -- diagnostics/quickfix
   {
      'folke/trouble.nvim',
      cmd = { 'TroubleToggle', 'Trouble' },
      opts = require('modules.editor.setup.trouble').opts,
      keys = require('modules.editor.setup.trouble').keys,
   },

   -- block folding
   -- {
   --    'kevinhwang91/nvim-ufo',
   --    enable = false,
   --    event = 'BufReadPre',
   --    dependencies = {
   --       'kevinhwang91/promise-async',
   --       'luukvbaal/statuscol.nvim',
   --       'nvim-treesitter/nvim-treesitter',
   --    },
   --    opts = require('modules.editor.setup.ufo').opts,
   --    keys = require('modules.editor.setup.ufo').keys,
   -- },

   -- misc
   {
      'abecodes/tabout.nvim',
      event = 'InsertEnter',
      opts = require('modules.editor.setup.tabout').opts,
      keys = {
         { '<A-l>', modes = { 'n' } },
         { '<A-h>', modes = { 'n' } },
      },
   },
   {
      'KevinSilvester/import-cost.nvim',
      event = { 'BufReadPost *.{ts,tsx,js,cjs,mjs}', 'BufNewFile *.{ts,tsx,js,cjs,mjs}' },
      build = function() return HOST.is_win and 'pwsh install.ps1 npm' or 'sh install.sh' end,
      config = true,
   },
}
