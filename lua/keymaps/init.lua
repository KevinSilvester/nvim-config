local mapper = require('core.mapper')
local silent, noremap = mapper.silent, mapper.noremap
local opts = mapper.new_opts
local cmd = mapper.cmd
local nmap = mapper.nmap
local imap = mapper.imap
local vmap = mapper.vmap
local xmap = mapper.xmap

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

--
-- LEADER
vim.keymap.set('', '<Space>', '<Nop>', opts(noremap, silent))
vim.g.mapleader = ' '

--
-- NORMAL MODE --
nmap({
   -- Better window navigation
   { '<C-h>', '<C-w>h', opts(noremap, silent) },
   { '<C-j>', '<C-w>j', opts(noremap, silent) },
   { '<C-k>', '<C-w>k', opts(noremap, silent) },
   { '<C-l>', '<C-w>l', opts(noremap, silent) },

   -- Resize with arrows
   { '<A-J>', cmd('resize -2'), opts(noremap, silent) },
   { '<A-K>', cmd('resize +2'), opts(noremap, silent) },
   { '<A-H>', cmd('vertical resize -2'), opts(noremap, silent) },
   { '<A-L>', cmd('vertical resize +2'), opts(noremap, silent) },

   -- Navigate buffers
   { '<S-l>', cmd('bnext'), opts(noremap, silent) },
   { '<S-h>', cmd('bprevious'), opts(noremap, silent) },

   -- Move text up and down
   { '<A-j>', '<Esc>:m .+1<CR>==', opts(noremap, silent) },
   { '<A-k>', '<Esc>:m .-2<CR>==', opts(noremap, silent) },

   -- Close buffers
   { '<S-q>', cmd('Bdelete!'), opts(noremap, silent) },

   -- Delete Word
   { '<C-BS>', '<C-W>', opts(noremap, silent) },

   -- Refresh NvimTree
   { 'nr', cmd('NvimTreeRefresh'), opts(noremap, silent) },
})

--
-- INSERT MODE --
imap({
   -- Move text up and down
   { '<A-j>', '<Esc>:m .+1<CR>==gi', opts(noremap, silent) },
   { '<A-k>', '<Esc>:m .-2<CR>==gi', opts(noremap, silent) },

   -- Delete Word
   { '<C-BS>', '<C-W>', opts(noremap, silent) },
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

   -- Comment
   {
      '<leader>/',
      function()
         vim.api.nvim_feedkeys(esc, 'nx', false)
         require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end,
      opts(noremap, silent),
   },
})
