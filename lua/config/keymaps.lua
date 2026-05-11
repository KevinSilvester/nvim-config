-- stylua: ignore start

local m = require('core.mapper')

--
-- LEADER
vim.keymap.set('', '<Space>', '<Nop>', m.opts(m.noremap, m.silent))

--
-- NORMAL MODE --
m.nmap({
   { '<leader>L',  m.cmd('Lazy'),                          m.opts(m.noremap, m.silent, '[config] Lazy') },
   { '<leader>D',  function() log:dump() end,              m.opts(m.noremap, m.silent, '[config] Log Dump'), },
   { '<leader>br', function() buf_cache:refresh() end,     m.opts(m.noremap, m.silent, '[bufcache] Refresh current buffer cache'), },
   { '<leader>bR', function() buf_cache:refresh_all() end, m.opts(m.noremap, m.silent, '[bufcache] Refresh all buffer cache'), },
   { '<leader>bs', function() buf_cache:render() end,      m.opts(m.noremap, m.silent, '[bufcache] Render cache blocks'), },

   -- Better window navigation
   { '<C-h>',      '<C-w>h',                               m.opts(m.noremap, m.silent, '[config] Focus window (left)') },
   { '<C-j>',      '<C-w>j',                               m.opts(m.noremap, m.silent, '[config] Focus window (below)') },
   { '<C-k>',      '<C-w>k',                               m.opts(m.noremap, m.silent, '[config] Focus window (top)') },
   { '<C-l>',      '<C-w>l',                               m.opts(m.noremap, m.silent, '[config] Focus window (right)') },

   -- Resize with arrows
   { '<A-J>',      m.cmd('resize -2'),                     m.opts(m.noremap, m.silent, '[config] Resize -2 (Horizontal)') },
   { '<A-K>',      m.cmd('resize +2'),                     m.opts(m.noremap, m.silent, '[config] Resize +2 (Horizontal)') },
   { '<A-H>',      m.cmd('vertical resize -2'),            m.opts(m.noremap, m.silent, '[config] Resize -2 (Vertical)') },
   { '<A-L>',      m.cmd('vertical resize +2'),            m.opts(m.noremap, m.silent, '[config] Resize +2 (Vertical)') },

   -- Navigate buffers
   { '<S-l>',      m.cmd('bnext'),                         m.opts(m.noremap, m.silent, '[config] Switch buffer (right)') },
   { '<S-h>',      m.cmd('bprevious'),                     m.opts(m.noremap, m.silent, '[config] Switch buffer (left)') },

   -- Move text up and down
   { '<A-k>',      m.cmd('move .-2', '=='),                m.opts(m.noremap, m.silent, '[config] Move line up') },
   { '<A-j>',      m.cmd('move .+1', '=='),                m.opts(m.noremap, m.silent, '[config] Move line down') },

   -- Clear search highlight
   { '<leader>H',  m.cmd('nohlsearch'),                    m.opts(m.noremap, m.silent, '[config] Clear search hl') },
})

if HOST.is_mac then
   m.nmap({
      -- Resize with arrows
      { '<D-K>',    m.cmd('resize +2'),                                     m.opts(m.noremap, m.silent, '[config] Resize +2 (Horizontal)') },
      { '<D-J>',    m.cmd('resize -2'),                                     m.opts(m.noremap, m.silent, '[config] Resize -2 (Horizontal)') },
      { '<D-H>',    m.cmd('vertical resize -2'),                            m.opts(m.noremap, m.silent, '[config] Resize -2 (Vertical)') },
      { '<D-L>',    m.cmd('vertical resize +2'),                            m.opts(m.noremap, m.silent, '[config] Resize +2 (Vertical)') },

      -- Move text up and down
      { '<D-k>',    m.cmd('move .-2', '=='),                                m.opts(m.noremap, m.silent, '[config] Move line up') },
      { '<D-j>',    m.cmd('move .+1', '=='),                                m.opts(m.noremap, m.silent, '[config] Move line down') },
      { '<D-Up>',   m.cmd('call vm#commands#add_cursor_up(0, v:count1)'),   m.opts(m.noremap, m.silent) },
      { '<D-Down>', m.cmd('call vm#commands#add_cursor_down(0, v:count1)'), m.opts(m.noremap, m.silent) },
   })
end

--
-- INSERT MODE --
m.imap({
   -- Move text up and down
   { '<A-k>', m.esc(':move .-2', '==gi'), m.opts(m.noremap, m.silent, '[config] Move line up') },
   { '<A-j>', m.esc(':move .+1', '==gi'), m.opts(m.noremap, m.silent, '[config] Move line down') },
})

--
-- VISUAL MODE --
m.vmap({
   -- Stay in indent mode
   { '<',     '<gv',                        m.opts(m.noremap, m.silent, '[config] Indent left') },
   { '>',     '>gv',                        m.opts(m.noremap, m.silent, '[config] Indent right') },

   -- Better paste
   -- { '<C-p>', '"_dP',                    m.opts(m.noremap, m.silent, 'Paste without yank') }, -- set by yanky

   -- delete without yanking
   { 'D',     '"_d',                        m.opts(m.noremap, m.silent, '[config] Delete without yank') },

   -- move selected line / block of text in visual mode
   { '<A-k>', m.esc(":move '<-2", 'gv=gv'), m.opts(m.noremap, m.silent, '[config] Move line up') },
   { '<A-j>', m.esc(":move '>+1", 'gv=gv'), m.opts(m.noremap, m.silent, '[config] Move line down') },
})

-- stylua: ignore end
