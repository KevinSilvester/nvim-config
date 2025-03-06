local cmd = require('core.mapper').cmd
local M = {}

-- local input_win_opts = {
--    style = 'input',
--    relative = 'cursor',
--    col = 0,
--    row = -3,
--    width = 25,
-- }

-- local function rename_input(opts, on_confirm)
--    opts = opts or {}
--    opts.win = vim.tbl_extend('force', input_win_opts, opts.win or {})
--    log:info('rename_input', opts)
--    return Snacks.input(opts, on_confirm)
-- end

M.config = function()
   local opts = require('modules.cmp_lsp.lsp.servers')
   local lspconfig = require('lspconfig')
   local mason_lsp = require('mason-lspconfig')

   for _, server in ipairs(mason_lsp.get_installed_servers()) do
      -- using rust-tools.nvim and typescrip.nvim for better lsp config
      if server == 'rust_analyzer' or server == 'ts_ls' or server == 'tailwindcss' then
         goto continue
      end

      if opts.custom[server] ~= nil then
         lspconfig[server].setup(opts.custom[server])
      else
         lspconfig[server].setup(opts.default)
      end

      ::continue::
   end
end

-- stylua: ignore
M.keys = {
   { '<leader>lc', require('utils.lsp').server_capabilities,                               desc = '[utils] Get Capabilities' },
   { '<leader>ld', vim.diagnostic.open_float,                                              desc = '[builtin] Line Diagnostics' },
   { '<leader>lf', function() vim.lsp.buf.format({ async = true, timeout_ms = 1000 }) end, desc = '[builtin] Format File',     mode = { 'n' } },
   {
      '<leader>lf',
      function()
         vim.lsp.buf.format({
            async = true,
            timeout_ms = 1000,
            range = {
               ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
               ['end'] = vim.api.nvim_buf_get_mark(0, '>')
            }
         })
      end,
      desc = '[builtin] Format File',
      mode = { 'v' }
   },
   { '<leader>li',  cmd('LspInfo'),       desc = '[lspconfig] LSP Info' },
   {
      '<leader>lr',
      vim.lsp.buf.rename,
      desc = '[builtin] Rename'
   },
   { '<leader>lar', vim.lsp.codelens.run, desc = '[builtin] Run CodeLens Action' },
}

return M
