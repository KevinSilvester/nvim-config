---@diagnostic disable: missing-parameter
local M = {}

M.config = function()
   require('hover').config({
      providers = {
         -- Require providers
         'hover.providers.lsp',
         'hover.providers.gh',
         'hover.providers.gh_user',
         'hover.providers.dap',
         'hover.providers.man',
         -- require('hover.providers.dictionary')
      },
      preview_opts = {
         border = 'rounded',
      },
   })
end

M.keys = {
   -- {
   --    'gK',
   --    function()
   --       require('hover').enter()
   --    end,
   --    desc = '[hover] select hover',
   -- },
   -- {
   --    '<C-p>',
   --    function()
   --       require('hover').switch('previous')
   --    end,
   --    desc = '[hover] previous source',
   -- },
   -- {
   --    '<C-n>',
   --    function()
   --       require('hover').switch('next')
   --    end,
   --    desc = '[hover] next source',
   -- },
   -- {
   --    '<MouseMove>',
   --    function()
   --       require('hover').mouse()
   --    end,
   --    desc = 'hover.nvim (mouse)',
   -- },
}

return M
