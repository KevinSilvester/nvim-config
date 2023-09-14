return {
   ---------------------------------
   --         lsp plugins         --
   ---------------------------------
   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         'hrsh7th/cmp-nvim-lsp',
         'lvimuser/lsp-inlayhints.nvim',
         { 'b0o/schemastore.nvim', version = false },
         'folke/neodev.nvim',
         'SmiteshP/nvim-navic',
      },
      init = require('modules.cmp_lsp.setup.nvim-lspconfig').init,
      config = require('modules.cmp_lsp.setup.nvim-lspconfig').config,
      keys = require('modules.cmp_lsp.setup.nvim-lspconfig').keys,
   },
   {
      'folke/neodev.nvim',
      event = { 'BufReadPre *.lua', 'BufNewFile *.lua' },
      opts = require('modules.cmp_lsp.setup.neodev').opts,
   },
   {
      'williamboman/mason.nvim',
      opts = require('modules.cmp_lsp.setup.mason').opts,
      keys = require('modules.cmp_lsp.setup.mason').keys,
   },
   {
      'williamboman/mason-lspconfig.nvim',
      opts = {
         ensure_installed = DEFAULT_LSP_SERVERS,
         automatic_installation = true,
      },
   },
   {
      'nvimdev/lspsaga.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-treesitter/nvim-treesitter' },
      event = 'LspAttach',
      opts = require('modules.cmp_lsp.setup.lspsaga').opts,
      keys = require('modules.cmp_lsp.setup.lspsaga').keys,
   },
   {
      'jose-elias-alvarez/typescript.nvim',
      event = { 'BufReadPre *.{ts,tsx,js,cjs,mjs}', 'BufNewFile *.{ts,tsx,js,cjs,mjs}' },
      config = require('modules.cmp_lsp.setup.typescript').config,
   },
   {
      'simrat39/rust-tools.nvim',
      event = { 'BufReadPre *.rs', 'BufNewFile *.rs' },
      dependencies = { 'neovim/nvim-lspconfig' },
      opts = require('modules.cmp_lsp.setup.rust-tools').opts,
      config = require('modules.cmp_lsp.setup.rust-tools').config,
   },
   {
      'ray-x/go.nvim',
      dependencies = {
         'ray-x/guihua.lua',
         'neovim/nvim-lspconfig',
      },
      config = true,
      event = { 'CmdlineEnter' },
      ft = { 'go', 'gomod' },
      build = ':lua require("go.install").update_all_sync()',
   },

   { 'hrsh7th/cmp-nvim-lsp', dependencies = 'hrsh7th/nvim-cmp' },

   ---------------------------------
   --         cmp plugins         --
   ---------------------------------
   {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-path',
         'saadparwaiz1/cmp_luasnip',
         'f3fora/cmp-spell',
         'windwp/nvim-autopairs',
      },
      opts = require('modules.cmp_lsp.setup.cmp').opts,
      config = require('modules.cmp_lsp.setup.cmp').config,
   },
   {
      'L3MON4D3/LuaSnip',
      tag = 'v1.2.1',
      build = 'make install_jsregexp',
      event = 'InsertEnter',
      dependencies = 'rafamadriz/friendly-snippets',
      config = require('modules.cmp_lsp.setup.luasnip').config,
   },
   { 'rafamadriz/friendly-snippets' },
   {
      'windwp/nvim-autopairs',
      opts = {
         check_ts = true, -- treesitter integration
         disable_filetype = { 'TelescopePrompt' },
      },
   },

   ---------------------------------
   --           copilot           --
   ---------------------------------
   {
      'zbirenbaum/copilot.lua',
      enabled = not HOST.is_mac,
      dependencies = 'neovim/nvim-lspconfig',
      cmd = 'Copilot',
      opts = require('modules.cmp_lsp.setup.copilot').opts,
   },
   {
      'zbirenbaum/copilot-cmp',
      enabled = not HOST.is_mac,
      dependencies = { 'hrsh7th/nvim-cmp', 'zbirenbaum/copilot.lua' },
      event = 'InsertEnter',
      config = require('modules.cmp_lsp.setup.copilot-cmp').config,
   },

   ---------------------------------
   --      formatter+linter       --
   ---------------------------------
   {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = require('modules.cmp_lsp.setup.null-ls').config,
   },
}
