local function augroup(name)
   return vim.api.nvim_create_augroup('config_' .. name, { clear = true })
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
   callback = function()
      vim.cmd('tabdo wincmd =')
   end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
   -- group = augroup('last_loc'),
   callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
         pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
   end,
})

-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ 'FileType' }, {
   pattern = {
      'PlenaryTestPopup',
      'help',
      'lspinfo',
      'man',
      'notify',
      'qf',
      'spectre_panel',
      'startuptime',
      'tsplayground',
      'checkhealth',
   },
   callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
   end,
})

-- Remove statusline and tabline when in Alpha
vim.api.nvim_create_autocmd({ 'User' }, {
   pattern = { 'AlphaReady' },
   callback = function()
      vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
   end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
   callback = function()
      vim.cmd('set formatoptions-=cro')
   end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
   callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
   end,
})

-- vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
--    callback = function()
--       if not vim.g.neovide then
--          vim.cmd('hi Normal guibg=NONE')
--          vim.cmd('hi NormalNC guibg=NONE')
--       end
--    end,
-- })

-- Autocmd to close nvim if nvim-tree is the last buffer
-- ref: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#ppwwyyxx
vim.api.nvim_create_autocmd('QuitPre', {
   callback = function()
      local invalid_win = {}
      local wins = vim.api.nvim_list_wins()

      for _, w in ipairs(wins) do
         local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
         if bufname:match('NvimTree_') ~= nil or bufname == '' then
            table.insert(invalid_win, w)
         end
      end

      if #invalid_win == #wins - 1 then
         for _, w in ipairs(invalid_win) do
            vim.api.nvim_win_close(w, true)
         end
      end
   end,
})

-- ref: https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open-for-directories-and-change-neovims-directory
vim.api.nvim_create_autocmd('VimEnter', {
   callback = function(data)
      local directory = vim.fn.isdirectory(data.file) == 1
      if not directory then
         return
      end
      vim.cmd.cd(data.file)
      xpcall(require('nvim-tree.api').tree.open, function()
         log.error('config.autocmd', 'Plugin `nvim-tree` not found')
      end)
   end,
})
