local mapper = require('core.mapper')
local silent, noremap = mapper.silent, mapper.noremap
local opts = mapper.opts
local cmd = mapper.cmd
local nmap = mapper.nmap
local imap = mapper.imap
local vmap = mapper.vmap
local xmap = mapper.xmap

--
-- LEADER
vim.keymap.set('', '<Space>', '<Nop>', opts(noremap, silent))
vim.g.mapleader = ' '

--
-- NORMAL MODE --
nmap({
   { '<leader>L', cmd('Lazy'), opts(noremap, silent, 'Lazy') },
   { '<leader>D', function() log:dump() end, opts(noremap, silent, 'Log Dump') },
   {
      '<leader>br',
      function()
         buf_cache:refresh()
      end,
      opts(noremap, silent, '[bufcache] Refresh current buffer cache'),
   },
   {
      '<leader>bR',
      function()
         buf_cache:refresh_all()
      end,
      opts(noremap, silent, '[bufcache] Refresh all buffer cache'),
   },
   {
      '<leader>bs',
      function()
         buf_cache:render()
      end,
      opts(noremap, silent, '[bufcache] Render cache blocks'),
   },

   -- Better window navigation
   { '<C-h>', '<C-w>h', opts(noremap, silent, 'Focus window (left)') },
   { '<C-j>', '<C-w>j', opts(noremap, silent, 'Focus window (below)') },
   { '<C-k>', '<C-w>k', opts(noremap, silent, 'Focus window (top)') },
   { '<C-l>', '<C-w>l', opts(noremap, silent, 'Focus window (right)') },

   -- Resize with arrows
   { '<A-J>', cmd('resize -2'), opts(noremap, silent, 'Resize -2 (Horizontal)') },
   { '<A-K>', cmd('resize +2'), opts(noremap, silent, 'Resize +2 (Horizontal)') },
   { '<A-H>', cmd('vertical resize -2'), opts(noremap, silent, 'Resize -2 (Vertical)') },
   { '<A-L>', cmd('vertical resize +2'), opts(noremap, silent, 'Resize +2 (Vertical)') },

   -- Navigate buffers
   { '<S-l>', cmd('bnext'), opts(noremap, silent, 'Switch buffer (right)') },
   { '<S-h>', cmd('bprevious'), opts(noremap, silent, 'Switch buffer (left)') },

   -- Move text up and down
   { '<A-j>', '<Esc>:m .+1<CR>==', opts(noremap, silent, 'Move line down') },
   { '<A-k>', '<Esc>:m .-2<CR>==', opts(noremap, silent, 'Move line up') },

   -- Delete Word
   { '<C-BS>', '<C-W>', opts(noremap, silent) },

   -- Delete Word
   { '<leader>H', cmd('nohlsearch'), opts(noremap, silent) },
})

if HOST.is_mac then
   nmap({
      -- Resize with arrows
      { '<D-J>', cmd('resize -2'), opts(noremap, silent) },
      { '<D-K>', cmd('resize +2'), opts(noremap, silent) },
      { '<D-H>', cmd('vertical resize -2'), opts(noremap, silent) },
      { '<D-L>', cmd('vertical resize +2'), opts(noremap, silent) },

      -- Move text up and down
      { '<D-j>', '<Esc>:m .+1<CR>==', opts(noremap, silent) },
      { '<D-k>', '<Esc>:m .-2<CR>==', opts(noremap, silent) },
      { '<D-Up>', cmd('call vm#commands#add_cursor_up(0, v:count1)'), opts(noremap, silent) },
      { '<D-Down>', cmd('call vm#commands#add_cursor_down(0, v:count1)'), opts(noremap, silent) },
   })
end

--
-- INSERT MODE --
imap({
   -- Move text up and down
   { '<A-j>', '<Esc>:m .+1<CR>==gi', opts(noremap, silent) },
   { '<A-k>', '<Esc>:m .-2<CR>==gi', opts(noremap, silent) },

   -- Icon Picker
   -- { '<C-I>', cmd('IconPickerInsert'), opts(noremap, silent) },
})

--
-- VISUAL MODE --
vmap({
   -- Stay in indent mode
   { '<', '<gv', opts(noremap, silent) },
   { '>', '>gv', opts(noremap, silent) },

   -- Better paste
   { 'p', '"_dP', opts(noremap, silent) },

   -- Delete Word
   { '<C-BS>', '<C-W>', opts(noremap, silent) },
})

--
-- VISUAL BLOCK MODE --
xmap({
   -- move selected line / block of text in visual mode
   { 'J', cmd("move '>+1<CR>gv-gv"), opts(noremap, silent) },
   { 'K', cmd("move '<-2<CR>gv-gv"), opts(noremap, silent) },
   { '<A-j>', cmd("move '>+<CR>gv-gv"), opts(noremap, silent) },
   { '<A-k>', cmd("move '<-2<CR>gv-gv"), opts(noremap, silent) },
})
