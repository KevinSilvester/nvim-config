local plugin = require('core.pack').register_plugin
local conf = require('modules.editor.config')

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
})
plugin({
   'JoosepAlviste/nvim-ts-context-commentstring',
   after = 'nvim-treesitter',
})
plugin({
   'nvim-treesitter/nvim-treesitter-textobjects',
   after = 'nvim-treesitter',
})
plugin({
   'windwp/nvim-ts-autotag',
   after = 'nvim-treesitter',
})
plugin({
   'andymass/vim-matchup',
   after = 'nvim-treesitter',
})

-- multiple cursors
plugin({
   'mg979/vim-visual-multi',
   event = 'BufReadPost',
})

-- comments
plugin({
   'numToStr/Comment.nvim',
   config = conf.comment,
   requires = { 'folke/todo-comments.nvim' },
   after = { 'nvim-treesitter', 'nvim-ts-context-commentstring' },
})
plugin({
   'folke/todo-comments.nvim',
   event = 'BufRead',
   config = conf.todo_comments,
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
   'karb94/neoscroll.nvim',
   opt = true,
   event = 'BufReadPost',
   config = conf.neoscroll,
})
plugin({
   'wfxr/minimap.vim',
   opt = true,
   config = conf.minimap,
   cmd = {
      'Minimap',
      'MinimapClose',
      'MinimapToggle',
      'MinimapRescan',
      'MinimapRefresh',
      'MinimapUpdateHighlight',
   },
})

-- find + search + replace
plugin({
   'nvim-pack/nvim-spectre',
   opt = true,
   event = 'BufReadPost',
   requires = { 'plenary.nvim', 'nvim-web-devicons' },
   config = conf.nvim_spectre,
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
   event = 'BufReadPost',
   cmd = { 'DiffViewOpen' },
   config = conf.diffview,
})

-- package info
plugin({
   'vuki656/package-info.nvim',
   opt = true,
   event = { 'BufReadPost package.json' },
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
   'moll/vim-bbye',
   opt = true,
   event = 'BufReadPost',
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
   -- after = 'nvim-cmp',
   config = conf.tabout,
})
