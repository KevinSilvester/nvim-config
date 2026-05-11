local function augroup(name)
   return vim.api.nvim_create_augroup('config.autocmd.' .. name, { clear = true })
end

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

vim.api.nvim_create_autocmd({ 'Filetype' }, {
   group = augroup('shebang-detection'),
   desc = 'Set the filetype based on the shebang header',
   callback = function()
      local line = vim.fn.getline(1)
      local pattern1, pattern2 = '^#!.*/bin/env%s+(%w+)', '^#!.*/bin/(%w+)'
      local interpreter = line:match(pattern1) or line:match(pattern2)
      if interpreter then
         vim.api.nvim_set_option_value('filetype', interpreter, { buf = 0 })
      end
   end,
})

-- Set `filetype` to `license` for `LICENSE*` files (for cmp snippets to appear)
vim.api.nvim_create_autocmd({ 'FileType' }, {
   group = augroup('license'),
   desc = 'Set `filetype` to `license` for `LICENSE*` files',
   pattern = { 'text', 'markdown' },
   callback = function(event)
      local filename = vim.fn.expand('%:t')
      if filename:match('^LICENSE') then
         vim.bo[event.buf].filetype = 'license'
      end
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

-- Autocmd to close nvim if nvim-tree is the last buffer
-- ref: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#ppwwyyxx
vim.api.nvim_create_autocmd('QuitPre', {
   group = augroup('neo-tree-quit'),
   desc = 'Autoclose if neo-tree is last window',
   callback = function()
      local invalid_win = {}
      local wins = vim.api.nvim_list_wins()

      for _, w in ipairs(wins) do
         local bufnr = vim.api.nvim_win_get_buf(w)
         local bufname = vim.api.nvim_buf_get_name(bufnr)
         local bufft = vim.bo[bufnr].ft
         if bufname == '' or (bufft == 'neo-tree' or bufft == 'NvimTree') then
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

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
   callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(args.buf)
      if mark[1] > 0 and mark[1] <= line_count then
         vim.cmd('normal! g`"zz')
      end
   end,
})

-- vim.api.nvim_create_autocmd('LspProgress', {
--    buffer = 0,
--    callback = function(ev)
--       local value = ev.data.params.value
--       -- log:debug('config.autocmd', ev.data, true)
--       vim.api.nvim_echo({ { value.message or 'done' } }, false, {
--          id = 'lsp.' .. ev.data.params.token,
--          kind = 'progress',
--          source = 'vim.lsp',
--          title = value.title,
--          status = value.kind ~= 'end' and 'running' or 'success',
--          percent = value.percentage,
--       })
--    end,
-- })

local active_count = 0

vim.api.nvim_create_autocmd('LspProgress', {
   buffer = 0,
   callback = function(ev)
      local value = ev.data.params.value
      -- log:debug('config.autocmd', ev.data, true)

      if value.kind == 'begin' then
         active_count = active_count + 1
         if value.percentage then
            vim.api.nvim_ui_send(string.format('\027]9;4;1;%d\027\\', value.percentage))
         else
            vim.api.nvim_ui_send('\027]9;4;3\027\\')
         end
      elseif value.kind == 'report' then
         if value.percentage then
            vim.api.nvim_ui_send(string.format('\027]9;4;1;%d\027\\', value.percentage))
         else
            vim.api.nvim_ui_send('\027]9;4;3\027\\')
         end
      elseif value.kind == 'end' then
         active_count = math.max(0, active_count - 1)
         if active_count == 0 then
            vim.api.nvim_ui_send('\027]9;4;1;100\027\\')
            vim.defer_fn(function()
               vim.api.nvim_ui_send('\027]9;4;1;0\027\\')
            end, 100)
         end
      end
   end,
})
