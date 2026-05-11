local M = {}

M.config = function()
   local mc = require('multicursor-nvim')
   mc.setup()

   -- Mappings defined in a keymap layer only apply when there are
   -- multiple cursors. This lets you have overlapping mappings.
   mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

      -- Delete the main cursor.
      layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet('n', '<esc>', function()
         if not mc.cursorsEnabled() then
            mc.enableCursors()
         else
            mc.clearCursors()
         end
      end)
   end)

   -- Customize how cursors look.
   local hl = vim.api.nvim_set_hl
   hl(0, 'MultiCursorCursor', { reverse = true })
   hl(0, 'MultiCursorVisual', { link = 'Visual' })
   hl(0, 'MultiCursorSign', { link = 'SignColumn' })
   hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
   hl(0, 'MultiCursorDisabledCursor', { reverse = true })
   hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
   hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
end

-- stylua: ignore
M.keys = {
   -- Add or skip cursor above/below the main cursor
   {
      '<Up>',
      function() require('multicursor-nvim').lineSkipCursor(-1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Skip line cursor'
   },
   {
      '<Down>',
      function() require('multicursor-nvim').lineSkipCursor(1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Skip line cursor'
   },
   {
      '<C-Up>',
      function() require('multicursor-nvim').lineAddCursor(-1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Add line cursor'
   },
   {
      '<C-Down>',
      function() require('multicursor-nvim').lineAddCursor(1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Add line cursor'
   },

   -- Add or skip adding a new cursor by matching word/selection
   {
      '<C-n>',
      function() require('multicursor-nvim').matchAddCursor(1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Match and Add Down',
   },
   {
      '<C-s>',
      function() require('multicursor-nvim').matchSkipCursor(1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Match and Skip Down',
   },
   {
      '♠', -- <C-S-n> triggers wezterm.action.SendString('♠')
      function() require('multicursor-nvim').matchAddCursor(-1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Match and Add Up',
   },
   {
      '‽', -- <C-S-s> triggers wezterm.action.SendString('‽')
      function() require('multicursor-nvim').matchSkipCursor(-1) end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Match and Skip Up',
   },

   -- toggle cursor
   {
      '<C-q>',
      function() require('multicursor-nvim').toggleCursor() end,
      mode = { 'n', 'x' },
      desc = '[multicursor] Toggle Cursors',
   },

   -- Add and remove cursors with control + left click
   {
      '<C-LeftMouse>',
      function() require('multicursor-nvim').handleMouse() end,
      desc = '[multicursor] Left Mouse Down',
   },
   {
      '<C-LeftDrag>',
      function() require('multicursor-nvim').handleMouseDrag() end,
      desc = '[multicursor] Left Mouse Drag',
   },
   {
      '<C-LeftRelease>',
      function() require('multicursor-nvim').handleMouseRelease() end,
      desc = '[multicursor] Left Mouse Release',
   },
}

return M
