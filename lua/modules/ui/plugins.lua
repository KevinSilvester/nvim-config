return {
   -- colorschemes
   {
      'catppuccin/nvim',
      name = 'catppuccin',
      init = function()
         vim.g.catppuccin_flavour = 'mocha'
      end,
      lazy = false,
      priority = 1000,
      opts = {
         integrations = { native_lsp = { inlay_hints = { background = false } } },
      },
   },
   { 'folke/tokyonight.nvim', event = 'VeryLazy' },
   { 'rebelot/kanagawa.nvim', event = 'VeryLazy' },
   {
      'marko-cerovac/material.nvim',
      init = function()
         vim.g.material_style = 'deep ocean'
      end,
      event = 'VeryLazy',
   },
   { 'olimorris/onedarkpro.nvim', event = 'VeryLazy' },
   { 'comfysage/evergarden', event = 'VeryLazy' },
   { 'ellisonleao/gruvbox.nvim', event = 'VeryLazy' },
   {
      'neanias/everforest-nvim',
      name = 'everforest',
      opts = { background = 'hard', ui_contrast = 'high' },
      event = 'VeryLazy',
   },

   -- file icons
   {
      'nvim-tree/nvim-web-devicons',
      lazy = true,
      opts = {
         override_by_filename = {
            ['Cargo.toml'] = {
               icon = '',
               color = '#9c4221',
               cterm_color = '124',
               name = 'Toml',
            },
         },
      },
   },

   -- background transparency
   {
      'xiyaowong/transparent.nvim',
      lazy = false,
      cmd = { 'TransparentEnable', 'TransparentDisable', 'TransparentToggle' },
      config = function()
         require('transparent').setup({})
         if vim.env.TERM_PROGRAM == 'WezTerm' and not vim.g.neovide then
            vim.cmd('TransparentEnable')
         else
            vim.cmd('TransparentDisable')
         end
      end,
   },

   -- bufferline
   {
      -- enabled = false,
      'akinsho/bufferline.nvim',
      version = 'v4.*',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      event = { 'BufReadPost', 'BufNewFile' },
      -- stylua: ignore
      keys = {
         { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>',            desc = '[bufferline] Toggle pin' },
         { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = '[bufferline] Delete non-pinned buffers' },
      },
      opts = require('modules.ui.setup.bufferline').opts,
      config = true,
   },

   -- statusline
   {
      'KevinSilvester/lualine.nvim',
      dependencies = {
         'lewis6991/gitsigns.nvim',
         'nvimtools/none-ls.nvim',
         -- 'ThePrimeagen/harpoon',
      },
      event = { 'BufReadPost', 'BufNewFile' },
      opts = require('modules.ui.setup.lualine').opts,
      config = require('modules.ui.setup.lualine').config,
   },

   -- winbar
   {
      'Bekaboo/dropbar.nvim',
      event = 'VeryLazy',
      opts = require('modules.ui.setup.dropbar').opts,
   },

   -- fold/statuscolumn
   {
      'luukvbaal/statuscol.nvim',
      config = require('modules.ui.setup.statuscol').config,
      event = 'BufEnter',
   },

   -- noicer ui
   {
      'folke/noice.nvim',
      enabled = true,
      event = 'VeryLazy',
      opts = require('modules.ui.setup.noice').opts,
      keys = require('modules.ui.setup.noice').keys,
   },

   -- lsp progress
   {
      'j-hui/fidget.nvim',
      tag = 'v1.6.1',
      enabled = true,
      event = 'LspAttach',
      dependencies = 'neovim/nvim-lspconfig',
      opts = {
         notification = { window = { winblend = 0 } },
      },
   },

   -- preview color
   {
      'catgoose/nvim-colorizer.lua',
      event = 'VeryLazy',
      opts = {
         filetypes = { '*', '!NvimTree', '!neo-tree', '!lazy', '!toggleterm', '!alpha', '!mason', 'cmp_doc' },
         use_default_options = {
            mode = 'background',
            css = true,
            names = false,
            tailwind = 'lsp',
            tailwind_opts = {
               update_names = true,
            },
            virtualtext = '󰝤',
            virtualtext_inline = 'before',
            virtualtext_mode = 'foreground',
         },
      },
      config = function(_, opts)
         require('colorizer').setup(opts)
      end,
   },

   -- side/file explorer
   {
      'nvim-neo-tree/neo-tree.nvim',
      enabled = true,
      cmd = 'Neotree',
      lazy = true,
      branch = 'v3.x',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
         'MunifTanjim/nui.nvim',
      },
      opts = require('modules.ui.setup.neo-tree').opts,
      config = require('modules.ui.setup.neo-tree').config,
      keys = require('modules.ui.setup.neo-tree').keys,
   },

   -- cure-border
   {
      'eandrju/cellular-automaton.nvim',
      event = 'VeryLazy',
      -- cmd = 'CellularAutomation',
   },

   { 'NStefan002/speedtyper.nvim', config = true, cmd = 'Speedtyper' },
}
