local cmd = require('core.mapper').cmd

-- plugin({
--    'rcarriga/nvim-dap-ui',
--    opt = true,
--    after = 'nvim-dap',
--    config = conf.dapui,
-- })

return {
   -- session+project management
   {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = {
         dir = PATH.cache .. '/session/',
         options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals' },
         pre_save = function()
            log.debug('modules.tools.persistence', 'Session saved')
         end,
      },
      -- stylua: ignore
      keys = {
         { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
         { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
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

   -- fuzzy finder
   {
      'KevinSilvester/telescope.nvim',
      branch = 'fix/json_file_preview',
      -- tag = '0.1.1',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = require('modules.tools.setup.telescope').config,
      keys = require('modules.tools.setup.telescope').keys,
      cmd = 'Telescope',
   },
   {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'KevinSilvester/telescope.nvim' },
      config = function()
         require('telescope').load_extension('file_browser')
      end,
   },
   {
      'nvim-telescope/telescope-fzf-native.nvim',
      dependencies = { 'KevinSilvester/telescope.nvim' },
      build = 'make',
      config = function()
         require('telescope').load_extension('file_browser')
      end,
   },

   -- keymap helper
   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = require('modules.tools.setup.which-key').opts,
      config = require('modules.tools.setup.which-key').config,
   },

   -- search and replace
   {
      'nvim-pack/nvim-spectre',
      dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
      opts = require('modules.tools.setup.spectre').opts,
      keys = require('modules.tools.setup.spectre').keys,
   },

   -- nerd font icons + emoji picker
   {
      'ziontee113/icon-picker.nvim',
      opts = { disable_legacy_commands = true },
      keys = {
         { '<leader>ii', cmd('IconPickerNormal'), desc = 'Pick Icons' },
         { '<leader>iy', cmd('IconPickerYank'), desc = 'Yank Icons' },
      },
   },

   -- WARNNING: Cursor disappears after using plugin
   -- colour picker
   -- {
   --    'max397574/colortils.nvim',
   --    cmd = 'Colortils',
   --    opts = {
   --       default_format = 'hsl'
   --    },
   --    config = true
   -- },

   -- package info
   {
      'vuki656/package-info.nvim',
      event = { 'BufReadPre package.json' },
      dependencies = 'nui.nvim',
      opts = require('modules.tools.setup.package-info').opts,
      keys = require('modules.tools.setup.package-info').keys,
      config = require('modules.tools.setup.package-info').config,
   },
   {
      'saecki/crates.nvim',
      tag = 'v0.3.0',
      event = { 'BufReadPre Cargo.toml' },
      dependencies = 'plenary.nvim',
      opts = require('modules.tools.setup.crates').opts,
      config = require('modules.tools.setup.crates').config,
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

   -- misc
   {
      'iamcco/markdown-preview.nvim',
      build = 'cd app && npm i',
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
}
