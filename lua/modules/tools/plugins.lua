local m = require('core.mapper')

-- plugin({
--    'rcarriga/nvim-dap-ui',
--    opt = true,
--    after = 'nvim-dap',
--    config = conf.dapui,
-- })

return {
   -- measure startuptime
   {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
         vim.g.startuptime_tries = 10
      end,
   },

   -- session+project management
   {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = {
         dir = PATH.cache .. '/session/',
         options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals' },
         pre_save = function()
            log:info('modules.tools.persistence', 'Session saved')
         end,
      },
      -- stylua: ignore
      keys = {
         {
            "<leader>qs",
            function() require("persistence").load() end,
            desc = "[persistence] Restore Session"
         },
         {
            "<leader>ql",
            function() require("persistence").load({ last = true }) end,
            desc = "[persistence] Restore Last Session"
         },
         {
            "<leader>qd",
            function() require("persistence").stop() end,
            desc = "[persistence] Don't Save Current Session"
         },
      },
   },
   {
      'ahmedkhalf/project.nvim',
      event = 'VeryLazy',
      opts = {
         detection_methods = { 'pattern' },
         patterns = { '.git', 'Makefile', 'package.json', 'Cargo.toml' },
      },
      config = function(_, opts)
         require('project_nvim').setup(opts)
      end,
   },
   -- {
   --    'polarmutex/git-worktree.nvim',
   --    dependencies = { 'nvim-lua/plenary.nvim', },
   --    config = true,
   -- },
   {
      'tpope/vim-fugitive',
      lazy = true,
      cmd = {
         'Git',
         'Gedit',
         'Gsplit',
         'Gdiffsplit',
         'Gvdiffsplit',
         'Gread',
         'Gwrite',
         'Ggrep',
         'Glgrep',
         'GMove',
         'GRename',
         'GDelete',
         'GRemove',
         'GBrowse',
      },
   },

   -- keymap helper
   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = require('modules.tools.setup.which-key').opts,
      config = require('modules.tools.setup.which-key').config,
   },

   -- search and replace
   -- {
   --    'nvim-pack/nvim-spectre',
   --    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
   --    opts = require('modules.tools.setup.spectre').opts,
   --    keys = require('modules.tools.setup.spectre').keys,
   -- },
   -- {
   --    'MagicDuck/grug-far.nvim',
   --    dependencies = { 'nvim-tree/nvim-web-devicons' },
   --    opts = require('modules.tools.setup._spectre').opts,
   --    keys = require('modules.tools.setup.grug-far').keys,
   -- },

   -- nerd font icons + emoji picker
   {
      'ziontee113/icon-picker.nvim',
      opts = { disable_legacy_commands = true },
      keys = {
         { '<leader>ii', m.cmd('IconPickerNormal'), desc = '[icon-picker] Pick Icons' },
         { '<leader>iy', m.cmd('IconPickerYank'), desc = '[icon-picker] Yank Icons' },
      },
   },

   -- better yank
   {
      'gbprod/yanky.nvim',
      config = true,
      keys = require('modules.tools.setup.yanky').keys,
   },

   -- Paste Images
   {
      'HakonHarnes/img-clip.nvim',
      event = 'BufEnter',
      keys = {
         { '<leader>ip', m.cmd('PasteImage'), desc = '[img-clip] Paste image' },
      },
      cmd = 'PasteImage',
   },

   -- useful text objects
   {
      'chrisgrieser/nvim-various-textobjs',
      lazy = false,
      opts = { keymaps = { useDefaults = true } },
   },

   -- snippet maker
   {
      'chrisgrieser/nvim-scissors',
      opts = { jsonFormatter = 'jq', snippetSelection = { picker = 'snacks' } },
      config = true,
      -- stylua: ignore
      keys = {
         {
            '<leader>;a',
            function() require('scissors').addNewSnippet() end,
            desc = '[nvim-scissors] Add Snippet',
            mode = { 'n', 'x' }
         },
         { '<leader>;e', function() require('scissors').editSnippet() end, desc = '[nvim-scissors] Edit Snippet' },
      },
   },

   -- smarter w,b,e
   -- { 'chrisgrieser/nvim-spider', keys = require('modules.tools.setup.nvim-spider').keys },

   -- colour picker
   {
      'max397574/colortils.nvim',
      cmd = 'Colortils',
      opts = {
         default_format = 'hsl',
         mappings = {
            replace_default_format = '<S-cr>',
            replace_choose_format = 'g<S-cr>',
         },
      },
   },

   -- HARPOON
   -- {
   --    'ThePrimeagen/harpoon',
   --    -- dir = '/home/kevin/projects/harpoon',
   --    dependencies = { 'nvim-lua/plenary.nvim' },
   --    branch = 'harpoon2',
   --    config = require('modules.tools.setup.harpoon').config,
   --    keys = require('modules.tools.setup.harpoon').keys,
   --    enabled = false,
   -- },

   -- package info
   {
      'vuki656/package-info.nvim',
      event = { 'BufReadPre package.json', 'BufNewFile package.json' },
      dependencies = 'MunifTanjim/nui.nvim',
      opts = require('modules.tools.setup.package-info').opts,
      config = require('modules.tools.setup.package-info').config,
   },
   {
      'saecki/crates.nvim',
      tag = 'v0.7.1',
      event = { 'BufReadPre Cargo.toml', 'BufNewFile Cargo.toml' },
      dependencies = 'nvim-lua/plenary.nvim',
      opts = require('modules.tools.setup.crates').opts,
   },

   -- terminal in neovim
   {
      'akinsho/toggleterm.nvim',
      cmd = {
         'ToggleTerm',
         'TermExec',
         'ToggleTermToggleAll',
         'ToggleTermSendCurrentLine',
         'ToggleTermSendVisualLines',
         'ToggleTermSendVisualSelection',
      },
      opts = require('modules.tools.setup.toggleterm').opts,
      keys = require('modules.tools.setup.toggleterm').keys,
   },

   -- debugger
   -- TODO: Setup Dap
   {
      'mfussenegger/nvim-dap',
      cmd = {
         'DapSetLogLevel',
         'DapShowLog',
         'DapContinue',
         'DapToggleBreakpoint',
         'DapToggleRepl',
         'DapStepOver',
         'DapStepInto',
         'DapStepOut',
         'DapTerminate',
      },
   },

   -- hide .env file variables
   {
      'laytan/cloak.nvim',
      event = { 'BufReadPre .env*', 'BufNewFile .env*' },
      cmd = { 'CloakEnable', 'CloakDisable', 'CloakToggle' },
      config = true,
   },

   -- colour picker
   { 'nvzone/volt', lazy = true },
   {
      'nvzone/minty',
      cmd = { 'Shades', 'Huefy' },
      lazy = true,
   },

   -- show keys
   { 'nvzone/showkeys', cmd = { 'ShowkeysToggle' }, opts = { position = 'top-right' } },

   -- timer
   { 'nvzone/timerly', cmd = 'TimerlyToggle' },

   -- fancy menu
   {
      'nvzone/menu',
      lazy = true,
      keys = {
         {
            '<C-t>',
            function()
               require('menu').open('default')
            end,
            desc = '[menu] open',
         },
         {
            '<RightMouse>',
            function()
               vim.cmd('normal! \\<RightMouse>')
               local option = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
               require('menu').open(option, { mouse = true })
            end,
            desc = '[menu] open',
         },
         {
            '<C-RightMouse>',
            function()
               vim.cmd('normal! \\<RightMouse>')
               if vim.tbl_contains(buf_cache._excluded_ft, vim.bo.ft) then
                  return
               end
               require('menu').open('gitsigns', { mouse = true })
            end,
            desc = '[menu] open',
         },
      },
   },

   -- type stats
   { 'nvzone/typr', cmd = { 'Typr', 'TyprStats' }, dependencies = { 'nvzone/volt' } },

   {
      -- 'nvzone/floaterm',
      'Opyuu/floaterm', -- for rounded border support
      dependencies = 'nvzone/volt',
      opts = {
         border = 'rounded',
         mappings = {
            term = function(bufnr)
               require('floaterm').setup()
               m.buf_tmap(bufnr, {
                  {
                     '<C-_>',
                     m.cmd('FloatermToggle'),
                     m.opts(m.silent, m.noremap, m.nowait, '[floaterm] toggle'),
                  },
                  {
                     '<Esc>',
                     [[<C-\><C-n>]],
                     m.opts(m.silent, m.noremap, m.nowait, '[floaterm] escape terminal'),
                  },
               })
            end,
         },
      },
      keys = {
         { '<C-_>', m.cmd('FloatermToggle'), desc = '[floaterm] Toggle' },
      },
      cmd = 'FloatermToggle',
   },

   -- misc
   {
      'iamcco/markdown-preview.nvim',
      build = function()
         vim.fn['mkdp#util#install']()
      end,
      commit = 'a923f5fc5ba36a3b17e289dc35dc17f66d0548ee',
      cmd = {
         'MarkdownPreview',
         'MarkdownPreviewStop',
         'MarkdownPreviewToggle',
      },
      -- ft = 'markdown',
      event = { 'BufReadPost *.md', 'BufNewFile *.md' },
      init = function()
         vim.g.mkdp_filetypes = { 'markdown' }
         vim.g.mkdp_echo_preview_url = 1
      end,
   },
   {
      'monaqa/dial.nvim',
      keys = { '<C-a>', '<C-x>' },
   },
   {
      -- dir = '~/projects/wrapped.nvim',
      'aikhe/wrapped.nvim',
      dependencies = { 'nvzone/volt' },
      cmd = { 'NvimWrapped' },
      opts = { border = 'rounded' },
   },
   -- {
   --    'folke/zen-mode.nvim',
   --    config = true,
   --    cmd = 'ZenMode',
   --    keys = {
   --       {
   --          '<leader>z',
   --          function()
   --             require('zen-mode').toggle({ window = { width = 0.55 } })
   --          end,
   --          desc = 'Zen Mode',
   --       },
   --    },
   -- },
   -- {
   --    'shortcuts/no-neck-pain.nvim',
   --    cmd = {
   --       'NoNeckPain',
   --       'NoNeckPainResize',
   --       'NoNeckPainToggleLeftSide',
   --       'NoNeckPainToggleRightSide',
   --       'NoNeckPainWidthUp',
   --       'NoNeckPainWidthDown',
   --       'NoNeckPainScratchPad'
   --    },
   --    version = '*',
   -- },
}
