local cmp_nvim_lsp = require('cmp_nvim_lsp')
local mapper = require('core.mapper')
local buf_nmap = mapper.buf_nmap
local silent, noremap = mapper.silent, mapper.noremap
local opts = mapper.new_opts
local cmd = mapper.cmd

local M = {}

---Setup LSP keymaps
---@private
---@param bufnr number The buffer number
M.set_lsp_keymaps = function(bufnr)
   -- stylua: ignore
   buf_nmap(bufnr, {
      { "K",     cmd("Lspsaga hover_doc"),                  opts(noremap, silent) },
      { "D",     cmd("lua vim.lsp.buf.type_definintion()"), opts(noremap, silent) },
      { "gD",    cmd("lua vim.lsp.buf.declaration()"),      opts(noremap, silent) },
      { "gd",    cmd("Lspsaga peek_definition"),              opts(noremap, silent) },
      { "gi",    cmd("Lspsaga lsp_finder"),                 opts(noremap, silent) },
      { "gl",    cmd("Lspsaga show_line_diagnostics"),      opts(noremap, silent) },
      { "gr",    cmd("lua vim.lsp.buf.references()"),       opts(noremap, silent) },
      { "gQ",    cmd("lua vim.diagnostic.setqflist()"),     opts(noremap, silent) },
      { "<C-[>", cmd("Lspsaga diagnostic_jump_prev"),       opts(noremap, silent) },
      { "<C-]>", cmd("Lspsaga diagnostic_jump_next"),       opts(noremap, silent) },
      {
         "<A-[>",
         cmd('lua require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })'),
         opts(noremap, silent)
      },
      {
         "<A-]>",
         cmd('lua require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })'),
         opts(noremap, silent)
      },
   })
end

---Attach nvim-navic
---@private
---@param client table The LSP client
---@param bufnr number The buffer number
M.attach_navic = function(client, bufnr)
   vim.g.navic_silence = true
   local status_ok, navic = pcall(require, 'nvim-navic')
   if status_ok then
      navic.attach(client, bufnr)
      -- vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
   end
end

M.diagnostics = function()
   local icons = require('modules.ui.icons').diagnostics

   local signs = {
      { name = 'DiagnosticSignError', text = icons.Error },
      { name = 'DiagnosticSignWarn', text = icons.Warning },
      { name = 'DiagnosticSignHint', text = icons.Hint },
      { name = 'DiagnosticSignInfo', text = icons.Info },
   }

   for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
   end

   vim.diagnostic.config({
      virtual_text = true, -- show virtual text
      signs = { active = signs }, -- show signs
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
         focusable = true,
         style = 'minimal',
         border = 'rounded',
         source = 'always',
         header = '',
         prefix = '',
      },
   })
end

M.handlers = function()
   local h = {
      -- to disable notifications in vim.lsp.buf.hover
      -- ref: https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
      -- alt: https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-1297599534
      ['textDocument/hover'] = function(_, result, ctx, config)
         config = config or {}
         config.focus_id = ctx.method
         if not (result and result.contents) then
            return
         end
         local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
         markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
         if vim.tbl_isempty(markdown_lines) then
            return
         end
         return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
      end,
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
   }

   for k, v in pairs(h) do
      vim.lsp.handlers[k] = v
   end
end

---Enable completions from lsp
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

---After attaching to a buffer, set keymaps, attach nvim-navic and vim-illuminate
---@param client table
---@param bufnr number
M.on_attach = function(client, bufnr)
   M.set_lsp_keymaps(bufnr)
   M.attach_navic(client, bufnr)
   require('illuminate').on_attach(client)

   local format_disable = {
      'sumneko_lua',
      'rust_analyzer',
      'marksman',
      'tsserver',
      'jsonls',
      'cssls',
      'html',
   }

   for _, server in pairs(format_disable) do
      if client.name == server then
         client.server_capabilities.document_formatting = false
      end
   end

   if client.name == 'jdtls' then
      vim.lsp.codelens.refresh()
      if JAVA_DAP_ACTIVE then
         require('jdtls').setup_dap({ hotcodereplace = 'auto' })
         require('jdtls.dap').setup_dap_main_class_configs()
      end
   end
end

return M
