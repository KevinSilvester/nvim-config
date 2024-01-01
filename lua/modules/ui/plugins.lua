return {
   -- colorschemes
   {
      'catppuccin/nvim',
      name = 'catppuccin',
      init = function()
         vim.g.catppuccin_flavour = 'mocha'
      end,
   },
   { 'glepnir/zephyr-nvim' },
   { 'folke/tokyonight.nvim' },
   { 'lunarvim/darkplus.nvim' },
   { 'lunarvim/onedarker.nvim' },
   { 'rebelot/kanagawa.nvim' },
   {
      'marko-cerovac/material.nvim',
      init = function()
         vim.g.material_style = 'deep ocean'
      end,
   },
   { 'olimorris/onedarkpro.nvim' },
   { 'olivercederborg/poimandres.nvim' },

   -- file icons
   { 'nvim-tree/nvim-web-devicons' },

   -- bufferline
   {
      'akinsho/bufferline.nvim',
      version = 'v3.*',
      dependencies = 'nvim-tree/nvim-web-devicons',
      event = { 'BufReadPost', 'BufNewFile' },
      -- stylua: ignore
      keys = {
         { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>',            desc = 'Toggle pin' },
         { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
         {
            '<leader>br',
            function() buf_cache:refresh() end,
            desc = 'Refresh cache block for current buffer',
         },
         {
            '<leader>bR',
            function() buf_cache:refresh_all() end,
            desc = 'Refresh cache block for all buffers',
         },
         {
            '<leader>bs',
            function() buf_cache:render() end,
            desc = 'Render cache blocks for all buffers',
         },
      },
      opts = require('modules.ui.setup.bufferline').opts,
      config = true,
   },

   -- statusline
   {
      'nvim-lualine/lualine.nvim',
      dependencies = {
         'lewis6991/gitsigns.nvim',
         'none-ls.nvim',
      },
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.ui.setup.lualine').opts,
      config = require('modules.ui.setup.lualine').config,
   },

   -- winbar
   {
      'utilyre/barbecue.nvim',
      name = 'barbecue',
      version = '*',
      event = 'VeryLazy',
      dependencies = {
         'SmiteshP/nvim-navic',
         'nvim-tree/nvim-web-devicons',
         'catppuccin/nvim',
      },
      opts = require('modules.ui.setup.barbecue').opts,
   },

   -- fold/statuscolumn
   {
      'luukvbaal/statuscol.nvim',
      config = require('modules.ui.setup.statuscol').config,
   },

   -- notifications
   {
      'rcarriga/nvim-notify',
      -- event = 'VeryLazy',
      opts = require('modules.ui.setup.notify').opts,
      init = require('modules.ui.setup.notify').init,
      config = require('modules.ui.setup.notify').config,
   },

   -- dashboard
   {
      'goolord/alpha-nvim',
      event = 'VimEnter',
      opts = require('modules.ui.setup.alpha').opts,
      config = require('modules.ui.setup.alpha').config,
   },

   -- noicer ui
   {
      'folke/noice.nvim',
      event = 'VeryLazy',
      opts = require('modules.ui.setup.noice').opts,
      keys = require('modules.ui.setup.noice').keys,
   },

   -- lsp progress
   {
      'j-hui/fidget.nvim',
      tag = 'v1.1.0',
      event = 'LspAttach',
      dependencies = 'neovim/nvim-lspconfig',
      opts = require('modules.ui.setup.fidget').opts,
      config = true,
   },

   -- preview color
   {
      'NvChad/nvim-colorizer.lua',
      event = 'VeryLazy',
      opts = {
         filetypes = { '*', '!NvimTree', '!lazy', '!toggleterm', '!alpha', '!mason' },
         mode = 'background',
         css = true,
         names = false,
         tailwind = true,
      },
      config = function(_, opts)
         require('colorizer').setup(opts)
      end,
   },

   -- inputs
   {
      'stevearc/dressing.nvim',
      dependencies = 'MunifTanjim/nui.nvim',
      opts = require('modules.ui.setup.dressing').opts,
      init = require('modules.ui.setup.dressing').init,
   },

   -- indent
   {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = require('modules.ui.setup.indent').opts,
   },

   -- side/file explorer
   -- {
   --    'nvim-neo-tree/neo-tree.nvim',
   --    branch = 'v2.x',
   --    cmd = 'Neotree',
   --    dependencies = {
   --       'nvim-lua/plenary.nvim',
   --       'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
   --       'MunifTanjim/nui.nvim',
   --    },
   --    deactivate = function()
   --       vim.cmd([[Neotree close]])
   --    end,
   --    opts = require('modules.ui.setup.neo-tree').opts,
   --    init = require('modules.ui.setup.neo-tree').init,
   --    keys = require('modules.ui.setup.neo-tree').keys,
   -- },
   {
      'nvim-tree/nvim-tree.lua',
      version = '*',
      cmd = {
         'NvimTreeOpen',
         'NvimTreeClose',
         'NvimTreeToggle',
         'NvimTreeFocus',
         'NvimTreeRefresh',
         'NvimTreeFindFile',
         'NvimTreeFindFileToggle',
         'NvimTreeClipboard',
         'NvimTreeResize',
         'NvimTreeCollapse',
         'NvimTreeCollapseKeepBuffers',
         'NvimTreeGenerateOnAttach',
      },
      dependencies = 'nvim-tree/nvim-web-devicons',
      opts = require('modules.ui.setup.nvim-tree').opts,
      config = require('modules.ui.setup.nvim-tree').config,
      keys = require('modules.ui.setup.nvim-tree').keys,
   },

   -- cure-border
   {
      'eandrju/cellular-automaton.nvim',
      cmd = 'CellularAutomaton',
   },
}
