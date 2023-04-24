-- -- keymap helper
-- plugin({
--    'folke/which-key.nvim',
--    config = conf.which_key,
-- })

-- -- terminal in neovim
-- plugin({
--    'akinsho/toggleterm.nvim',
--    opt = true,
--    cmd = 'ToggleTerm',
--    keys = '<C-P>',
--    config = conf.toggleterm,
-- })

-- -- colour picker
-- plugin({
--    'max397574/colortils.nvim',
--    -- opt = true,
--    event = 'BufReadPost',
--    cmd = 'Colortils',
--    config = conf.colortils,
-- })

-- -- icon picker
-- -- plugin({
-- --    'ziontee113/icon-picker.nvim',
-- --    opt = true,
-- --    event = 'BufReadPost',
-- --    cmd = {
-- --       'IconPickerNormal',
-- --       'IconPickerInsert',
-- --       'IconPickerYank',
-- --    },
-- --    config = conf.icon_picker,
-- -- })

-- plugin({
--    'nvim-pack/nvim-spectre',
--    opt = true,
--    event = 'BufReadPost',
--    requires = { 'plenary.nvim', 'nvim-web-devicons' },
--    config = conf.nvim_spectre,
-- })

-- -- debugger
-- plugin({
--    'mfussenegger/nvim-dap',
--    opt = true,
--    cmd = {
--       'DapSetLogLevel',
--       'DapShowLog',
--       'DapContinue',
--       'DapToggleBreakpoint',
--       'DapToggleRepl',
--       'DapStepOver',
--       'DapStepInto',
--       'DapStepOut',
--       'DapTerminate',
--    },
--    module = 'dap',
--    config = conf.dap,
-- })
-- plugin({
--    'rcarriga/nvim-dap-ui',
--    opt = true,
--    after = 'nvim-dap',
--    config = conf.dapui,
-- })

return {
   -- session management
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

   -- fuzzy finder
   {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.1',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = require('modules.tools.setup.telescope').config,
      keys = require('modules.tools.setup.telescope').keys,
      cmd = 'Telescope'
   },
   {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim', },
      config = function()
         require('telescope').load_extension('file_browser')
      end,
   },
   {
      'nvim-telescope/telescope-fzf-native.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim', },
      build = 'make',
      config = function()
         require('telescope').load_extension('file_browser')
      end,
   },

   -- package info
   {
      'vuki656/package-info.nvim',
      event = { 'BufReadPre package.json' },
      dependencies = 'nui.nvim',
      opts = require('modules.tools.setup.package-info').opts,
   },
   {
      'saecki/crates.nvim',
      event = { 'BufReadPre Cargo.toml' },
      dependencies = 'plenary.nvim',
      opts = require('modules.tools.setup.crates').opts,
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
