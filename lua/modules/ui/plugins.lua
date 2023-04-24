-- -- statusline
-- plugin({
--    'nvim-lualine/lualine.nvim',
--    opt = true,
--    after = { 'gitsigns.nvim', 'null-ls.nvim' },
--    config = conf.statusline,
-- })

-- -- command completion
-- plugin({
--    'gelguy/wilder.nvim',
--    config = conf.wilder,
-- })

return {
   -- colorschemes
   { 'catppuccin/nvim', name = 'catppuccin' },
   { 'glepnir/zephyr-nvim' },
   { 'folke/tokyonight.nvim' },
   { 'lunarvim/darkplus.nvim' },
   { 'lunarvim/onedarker.nvim' },
   { 'rebelot/kanagawa.nvim' },
   { 'marko-cerovac/material.nvim' },
   { 'olimorris/onedarkpro.nvim' },
   { 'olivercederborg/poimandres.nvim' },

   -- file icons
   { 'nvim-tree/nvim-web-devicons' },

   -- bufferline
   {
      'akinsho/bufferline.nvim',
      version = 'v3.*',
      dependencies = 'nvim-tree/nvim-web-devicons',
      event = 'BufReadPost',
      keys = {
         { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
         { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
      },
      opts = require('modules.ui.setup.bufferline'),
      config = true
   },

   -- notifications
   {
      'rcarriga/nvim-notify',
      -- event = 'VeryLazy',
      opts = require('modules.ui.setup.notify'),
      init = function()
         if not require('lazy.core.config').plugins['noice.nvim'] ~= nil then
            require('utils.fn').on_very_lazy(function()
               vim.notify = require('notify')
            end)
         end
      end,
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
      -- dependencies = {
      --    -- which key integration
      --    {
      --       'folke/which-key.nvim',
      --       opts = function(_, opts)
      --          if require('lazyvim.util').has('noice.nvim') then
      --             opts.defaults['<leader>sn'] = { name = '+noice' }
      --          end
      --       end,
      --    },
      -- },
      -- enabled = false,
      opts = require('modules.ui.setup.noice').opts,
      keys = require('modules.ui.setup.noice').keys,
   },

   -- preview color
   { 'NvChad/nvim-colorizer.lua', event = 'VeryLazy' },

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
      -- config = true,
   },
}
