local i = require('modules.ui.icons')

return {
   -- minimap
   {
      'nvim-mini/mini.map',
      config = require('modules.editor.setup.mini-map').config,
      keys = require('modules.editor.setup.mini-map').keys,
   },

   -- git
   {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = require('modules.editor.setup.gitsigns').opts,
      keys = require('modules.editor.setup.gitsigns').keys,
   },
   {
      'dlyongemallo/diffview.nvim',
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
      -- config = true,
      keys = require('modules.editor.setup.diffview').keys,
   },
   {
      'esmuellert/codediff.nvim',
      cmd = 'CodeDiff',
      opts = {
         diff = { layout = 'inline' },
         explorer = {
            view_mode = 'tree',
            initial_focus = 'original',
            ident_markers = false,
            icons = {
               folder_closed = i.fs.DirClosed,
               folder_open = i.fs.DirOpen,
            },
         },
      },
   },

   -- undo/redo
   {
      'tzachar/highlight-undo.nvim',
      config = true,
      event = 'VeryLazy',
   },

   -- multiple cursors
   -- {
   --    'mg979/vim-visual-multi',
   --    event = 'VeryLazy',
   --    enabled = false,
   -- },
   {
      'jake-stewart/multicursor.nvim',
      branch = '1.0',
      config = require('modules.editor.setup.multicursor').config,
      keys = require('modules.editor.setup.multicursor').keys,
   },

   -- navigation
   {
      'karb94/neoscroll.nvim',
      event = 'VeryLazy',
      opts = require('modules.editor.setup.neoscroll').opts,
      config = require('modules.editor.setup.neoscroll').config,
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
      dependencies = { { url = 'https://codeberg.org/andyg/leap.nvim' }, 'tpope/vim-repeat' },
      keys = function()
         ---@type LazyKeysSpec[]
         local ret = {}
         for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
            ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
         end
         return ret
      end,
      opts = { labeled_modes = 'nx' },
   },
   -- {
   --    url = 'https://codeberg.org/andyg/leap.nvim',
   --    dependencies = { 'tpope/vim-repeat' },
   --    keys = {
   --       { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
   --       { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
   --       { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
   --    },
   --    config = function(_, opts)
   --       local leap = require('leap')
   --       for k, v in pairs(opts) do
   --          leap.opts[k] = v
   --       end
   --       leap.add_default_mappings(true)
   --       vim.keymap.del({ 'x', 'o' }, 'x')
   --       vim.keymap.del({ 'x', 'o' }, 'X')
   --    end,
   -- },
   -- {
   --    'KevinSilvester/specs.nvim',
   --    event = 'CursorMoved',
   --    config = require('modules.editor.setup.specs').config,
   -- },
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
      branch = 'main',
      lazy = false,
      opts = {
         install_dir = vim.fn.stdpath('data') .. '/nvim-treesitter-main',
      },
      dependencies = {
         'nvim-treesitter/nvim-treesitter-textobjects',
         'nvim-treesitter/nvim-treesitter-locals',
         -- 'nvim-treesitter/nvim-treesitter-refactor',
         -- 'nvim-treesitter/nvim-treesitter-context',
         'JoosepAlviste/nvim-ts-context-commentstring',
         'andymass/vim-matchup',
      },
   },
   -- { 'JoosepAlviste/nvim-ts-context-commentstring', opts = { enable_autocmd = false } },
   {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      init = function()
         vim.g.no_plugin_maps = true
      end,
      opts = require('modules.editor.setup.nvim-treesitter-textobjects').opts,
      keys = require('modules.editor.setup.nvim-treesitter-textobjects').keys,
   },

   {
      'windwp/nvim-ts-autotag',
      dependencies = 'nvim-treesitter/nvim-treesitter',
      event = {
         'BufReadPost *.{html,vue,svelte,tsx,jsx,astro}',
         'BufNewFile *.{html,vue,svelte,tsx,jsx,astro}',
      },
      config = true,
   },

   -- markdown
   {
      'OXY2DEV/markview.nvim',
      opts = { preview = { icon_provider = 'devicons' } },
      ft = 'markdown',
      cmd = 'Markview',
   },
   {
      'OXY2DEV/helpview.nvim',
      opts = { preview = { icon_provider = 'devicons' } },
      ft = 'help',
      cmd = 'Helpview',
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
      opts = { max_join_length = 480 },
      -- stylua: ignore
      keys = {
         { '<leader>jt', function() require('treesj').toggle() end, desc = '[treesj] Toggle split/join block', },
         { '<leader>jj', function() require('treesj').join() end,   desc = '[treesj] Join block', },
         { '<leader>js', function() require('treesj').split() end,  desc = '[treesj] Split block', },
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
      cmd = { 'TodoTrouble' },
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.editor.setup.todo-comments').opts,
      keys = require('modules.editor.setup.todo-comments').keys,
   },

   -- diagnostics/quickfix
   {
      'folke/trouble.nvim',
      cmd = { 'Trouble' },
      opts = require('modules.editor.setup.trouble').opts,
      keys = require('modules.editor.setup.trouble').keys,
   },
   {
      'rachartier/tiny-inline-diagnostic.nvim',
      event = 'LspAttach',
      priority = 1000,
      opts = {
         signs = { vertical_end = ' ╰' },
         options = {
            show_all_diags_on_cursorline = true,
            enable_on_insert = true,
            multilines = true,
            show_source = true,
            virt_texts = { priority = 9000 },
         },
      },
   },

   -- block folding
   {
      'kevinhwang91/nvim-ufo',
      event = 'VeryLazy',
      dependencies = {
         'kevinhwang91/promise-async',
         'luukvbaal/statuscol.nvim',
      },
      opts = require('modules.editor.setup.ufo').opts,
      keys = require('modules.editor.setup.ufo').keys,
   },

   -- marks
   {
      'chentoast/marks.nvim',
      config = true,
      keys = require('modules.editor.setup.marks').keys,
   },

   -- undo
   { 'mbbill/undotree', cmd = 'UndotreeToggle' },

   -- misc
   -- {
   --    'abecodes/tabout.nvim',
   --    event = 'InsertCharPre',
   --    priority = 1000,
   --    opts = require('modules.editor.setup.tabout').opts,
   --    keys = {
   --       { '<Tab>', modes = { 'n' } },
   --       { '<S-Tab>', modes = { 'n' } },
   --    },
   --    enabled = false
   -- },
   {
      'barrett-ruth/import-cost.nvim',
      event = { 'BufReadPost *.{ts,tsx,js,cjs,mjs}', 'BufNewFile *.{ts,tsx,js,cjs,mjs}' },
      build = HOST.is_win and 'pwsh install.ps1 npm' or 'bash install.sh npm',
      config = true,
      enabled = false,
   },
}
