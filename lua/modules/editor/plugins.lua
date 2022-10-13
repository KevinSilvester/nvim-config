local plugin = require('core.pack').register_plugin
local conf = require('modules.editor.config')
local utils = require('core.utils')

-- hightlight selection
plugin({
   'RRethy/vim-illuminate',
   opt = true,
   event = 'BufReadPost',
   config = conf.illuminate,
})

-- syntax hightlighting
plugin({
   'nvim-treesitter/nvim-treesitter',
   run = ':TSUpdate',
   event = 'BufReadPost',
   config = conf.nvim_treesitter,
   requires = {
      {
         'JoosepAlviste/nvim-ts-context-commentstring',
         opt = true,
         after = 'nvim-treesitter',
      },
      {
         'nvim-treesitter/nvim-treesitter-textobjects',
         opt = true,
         after = 'nvim-treesitter',
      },
      {
         'windwp/nvim-ts-autotag',
         opt = true,
         after = 'nvim-treesitter',
      },
      {
         'andymass/vim-matchup',
         opt = true,
         after = 'nvim-treesitter',
      },
   },
})

-- comments
plugin({
   'numToStr/Comment.nvim',
   event = 'InsertEnter',
   config = conf.comment,
   requires = { 'folke/todo-comments.nvim' },
})

-- navigation
plugin({
   'rainbowhxch/accelerated-jk.nvim',
   opt = true,
   event = 'BufWinEnter',
   config = conf.accelerated_jk,
})
plugin({
   'phaazon/hop.nvim',
   opt = true,
   branch = 'v2',
   event = 'BufReadPost',
   config = conf.hop,
})
plugin({
   'karb94neoscroll.nvim',
   opt = true,
   event = 'BufReadPost',
   config = conf.neoscroll,
})

-- project management
plugin({
   'rmagatti/auto-session',
   opt = true,
   cmd = { 'SaveSession', 'RestoreSession', 'DeleteSession' },
   config = conf.auto_session,
})
plugin({
   'ahmedkhalf/project.nvim',
   opt = true,
   event = 'BufWinEnter',
   config = conf.project,
})
plugin({
   'sindrets/diffview.nvim',
   opt = true,
   after = 'plenary.nvim',
   cmd = { 'DiffViewOpen' },
   config = conf.diffview
})

-- package info
plugin({
   'vuki656/package-info.nvim',
   opt = true,
   event = { 'BufRead package.json' },
   after = 'nui.nvim',
   config = conf.package_info,
})
plugin({
   'saecki/crates.nvim',
   opt = true,
   event = { 'BufRead Cargo.toml' },
   after = 'plenary.nvim',
   config = conf.crates,
})

-- debugger
plugin({
   'mfussenegger/nvim-dap',
   opt = true,
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
   module = 'dap',
   config = conf.dap,
})
plugin({
   'rcarriga/nvim-dap-ui',
   opt = true,
   after = 'nvim-dap',
   config = conf.dapui,
})

-- misc
plugin({
   'max397574/better-escape.nvim',
   opt = true,
   event = 'BufReadPost',
   config = conf.better_escape,
})
plugin({
   'edluffy/specs.nvim',
   opt = true,
   event = 'CursorMoved',
   config = conf.specs,
})
plugin({
   'abecodes/tabout.nvim',
   opt = true,
   event = 'InsertEnter',
   wants = 'nvim-treesitter',
   after = 'nvim-cmp',
   config = conf.tabout,
})
