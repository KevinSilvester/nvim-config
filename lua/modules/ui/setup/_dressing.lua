local M = {}

M.opts = {
   input = {
      enabled = true, -- disable default vim.ui.input
      default_prompt = 'Input:',
      prompt_align = 'left', ---@type 'left'|'right'|'center'
      insert_only = true, -- close input if mode changes
      border = 'rounded',
      relative = 'cursor', ---@type 'cursor'|'editor'|'win'
      prefer_width = 20, -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      width = nil,
      -- min_width and max_width can be a list of mixed types.
      -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
      max_width = { 140, 0.9 },
      min_width = { 5, 0.05 },
      win_options = {
         winblend = 10, -- 0-100
         winhighlight = '', -- Change default highlight groups (see :help winhl)
      },
   },
   select = {
      enabled = true, -- disable default vim.ui.select
      -- Priority list of preferred vim.select implementations
      backend = { 'telescope', 'builtin', 'nui' },
      -- Trim trailing `:` from prompt
      trim_prompt = true,
      -- Options for telescope selector
      -- These are passed into the telescope picker directly. Can be used like:
      -- telescope = require('telescope.themes').get_ivy({...})
      telescope = nil,
      -- Options for nui Menu
      nui = {
         position = '50%',
         size = nil,
         relative = 'editor',
         border = {
            style = 'rounded',
         },
         buf_options = {
            swapfile = false,
            filetype = 'DressingSelect',
         },
         win_options = {
            winblend = 10,
         },
         max_width = 80,
         max_height = 40,
         min_width = 40,
         min_height = 10,
      },
      -- Options for built-in selector
      builtin = {
         border = 'rounded',
         relative = 'editor',
         win_options = {
            winblend = 10,
            winhighlight = '',
         },
         width = nil,
         max_width = { 140, 0.8 },
         min_width = { 40, 0.2 },
         height = nil,
         max_height = 0.9,
         min_height = { 10, 0.2 },
      },
      -- Used to override format_item. See :help dressing-format
      format_item_override = {},
      -- see :help dressing_get_config
      get_config = nil,
   },
}

M.init = function()
   ---@diagnostic disable-next-line: duplicate-set-field
   vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.select(...)
   end

   ---@diagnostic disable-next-line: duplicate-set-field
   vim.ui.input = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.input(...)
   end
end

return M
