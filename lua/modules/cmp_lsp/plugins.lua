local plugin = require('core.pack').register_plugin
local conf = require('modules.cmp_lsp.config')

---------------------------------
--         lsp plugins         --
---------------------------------
plugin({
   'folke/neodev.nvim',
   opt = true,
   event = 'BufReadPre',
   config = function()
      require('neodev').setup({})
   end,
})

plugin({
   'neovim/nvim-lspconfig',
   opt = true,
   event = 'BufReadPre',
   after = { 'cmp-nvim-lsp', 'neodev.nvim' },
   config = conf.nvim_lspconfig,
})

plugin({
   'glepnir/lspsaga.nvim',
   branch = 'main',
   opt = true,
   after = 'nvim-lspconfig',
   config = conf.lspsaga,
})

plugin({ 'b0o/schemastore.nvim' })
plugin({ 'simrat39/rust-tools.nvim' })

plugin({
   'williamboman/mason.nvim',
   opt = false,
   config = conf.mason,
   requires = {
      {
         'williamboman/mason-lspconfig.nvim',
         config = conf.mason_lspconfig,
      },
   },
})

plugin({
   'jose-elias-alvarez/null-ls.nvim',
   event = 'InsertEnter',
   config = conf.null_ls,
})

plugin({
   'jose-elias-alvarez/typescript.nvim',
})

plugin({
   'ray-x/lsp_signature.nvim',
   after = 'nvim-lspconfig',
   config = conf.lsp_signature,
})

plugin({
   'folke/lsp-colors.nvim',
   event = 'BufReadPre',
})

plugin({
   'mfussenegger/nvim-jdtls',
   after = 'nvim-lspconfig',
   ft = 'java',
})

plugin({
   'zbirenbaum/copilot.lua',
   after = 'nvim-lspconfig',
   event = { 'VimEnter' },
   config = conf.copilot,
})

plugin({
   'j-hui/fidget.nvim',
   event = 'BufReadPost',
   config = conf.fidget,
})

plugin({ 'lvimuser/lsp-inlayhints.nvim', after = 'nvim-lspconfig' })

plugin({
   'SmiteshP/nvim-navic',
   after = 'nvim-lspconfig',
   config = conf.nvim_navic,
})

---------------------------------
--         cmp plugins         --
---------------------------------
-- plugin({ "hrsh7th/cmp-nvim-lsp" })
-- plugin({ "hrsh7th/cmp-path" })
-- plugin({ "hrsh7th/cmp-buffer" })
-- plugin({ "hrsh7th/cmp-nvim-lsp-signature-help" })
-- plugin({ "hrsh7th/cmp-nvim-lua" })
-- plugin({ "saadparwaiz1/cmp_luasnip" })
-- plugin({ "lukas-reineke/cmp-under-comparator" })
-- plugin({ "hrsh7th/cmp-cmdline" })
-- plugin({ "hrsh7th/cmp-nvim-lsp-document-symbol" })
plugin({
   'L3MON4D3/LuaSnip',
   after = 'nvim-cmp',
   config = conf.lua_snip,
   requires = { 'rafamadriz/friendly-snippets' },
})

plugin({
   'hrsh7th/nvim-cmp',
   event = 'BufReadPost',
   requires = {
      { 'lukas-reineke/cmp-under-comparator' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua', after = 'cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer', after = 'cmp-spell' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },
      { 'f3fora/cmp-spell', after = 'cmp-path' },
      { 'kdheepak/cmp-latex-symbols', after = 'cmp-buffer' },
   },
   config = conf.cmp,
})

plugin({
   'windwp/nvim-autopairs',
   after = 'nvim-cmp',
   config = conf.nvim_autopairs,
})

plugin({
   'zbirenbaum/copilot-cmp',
   after = 'copilot.lua',
   config = function()
      require('copilot_cmp').setup()
   end,
})
