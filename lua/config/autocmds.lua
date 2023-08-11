local function augroup(name)
   return vim.api.nvim_create_augroup('config.autocmd.' .. name, { clear = true })
end

-- ---@return CacheBlock
-- local function cach_init()
--    return { lsp = {}, fmt = {}, copilot = false, treesitter = false }
-- end

-- vim.api.nvim_create_autocmd('LspAttach', {
--    group = augroup('cache-lsp'),
--    desc = 'Cache buf LSP+copilot',
--    callback = vim.schedule_wrap(function(event)
--       if buf_cache.buffers[event.buf] == nil then
--          buf_cache.buffers[event.buf] = cach_init()
--       end

--       for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = event.buf })) do
--          if client.name ~= 'copilot' and client.name ~= 'null-ls' then
--             table.insert(buf_cache.buffers[event.buf].lsp, client.name)
--          elseif client.name == 'copilot' then
--             buf_cache.buffers[event.buf].copilot = true
--          end
--       end
--       log.info('core.autocmd.lsp', buf_cache)
--    end),
-- })

-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
--    group = augroup('cache-treesitter'),
--    desc = 'Cache buf treesitter',
--    callback = vim.schedule_wrap(function(event)
--       -- buf_cache.active = event.buf
--       local ts = vim.treesitter.highlighter.active[event.buf] ~= nil
--       if buf_cache.buffers[event.buf] == nil then
--          buf_cache.buffers[event.buf] = cach_init()
--       end
--       buf_cache.buffers[event.buf].treesitter = ts
--       log.info('core.autocmd.lsp', buf_cache)
--    end),
-- })

-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--    group = augroup('cache-active-buffer'),
--    desc = 'Update active buffer',
--    callback = function(event)
--       buf_cache.active = event.buf
--       if buf_cache.buffers[event.buf] == nil then
--          buf_cache.buffers[event.buf] = cach_init()
--       end
--    end
-- })

-- vim.api.nvim_create_autocmd({ 'BufDelete' }, {
--    group = augroup('cache-clear'),
--    desc = 'Update active buffer',
--    callback = function(event)
--       buf_cache.buffers[event.buf] = nil
--       log.info('core.autocmd.lsp', buf_cache)
--    end,
-- })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
   group = augroup('resize'),
   desc = 'Resize splits if window got resized',
   callback = function()
      vim.cmd('tabdo wincmd =')
   end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
   group = augroup('last-loc'),
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
   group = augroup('keymap'),
   desc = 'Use "q" to quit from common plugins',
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
   group = augroup('options-bars'),
   pattern = { 'AlphaReady' },
   callback = function()
      vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
   end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
   group = augroup('options-format'),
   callback = function()
      vim.cmd('set formatoptions-=cro')
   end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
   group = augroup('hightlight-yank'),
   desc = 'Highlight yanked text',
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
   group = augroup('nvim-tree-quit'),
   desc = 'Autoclose if nvim-tree is last window',
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
   group = augroup('nvim-tree-open'),
   desc = 'Open nvim-tree if path is directory',
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
