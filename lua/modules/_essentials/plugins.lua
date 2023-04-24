return {
   { 'folke/lazy.nvim', lazy = false, tag = 'stable' },
   { 'nvim-lua/plenary.nvim', lazy = true },
   { 'nvim-lua/popup.nvim', lazy = true },
   { 'MunifTanjim/nui.nvim', lazy = true },

   -- measure startuptime
   {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
         vim.g.startuptime_tries = 10
      end,
   },

   -- makes some plugins dot-repeatable like leap
   { 'tpope/vim-repeat', event = 'VeryLazy' },
}
