local fn = vim.fn

------------------------------------------------------------------------
--                           host OS                                  --
------------------------------------------------------------------------
_G.HOST = {}
HOST.is_win = vim.loop.os_uname().sysname == 'Windows_NT'
HOST.is_linux = vim.loop.os_uname().sysname == 'Linux'
HOST.is_mac = vim.loop.os_uname().sysname == 'Darwin'
HOST.is_docker = fn.filereadable('/.dockerenv') == 1

------------------------------------------------------------------------
--                           lsp servers                              --
------------------------------------------------------------------------
_G.DEFAULT_LSP_SERVERS = {
   'astro',
   'awk_ls',
   'bashls',
   'clangd',
   'cmake',
   'cssls',
   'dockerls',
   'dotls',
   'emmet_ls',
   'eslint',
   'gopls',
   'graphql',
   'html',
   'jsonls',
   'pyright',
   'rust_analyzer',
   'sqls',
   'sumneko_lua',
   'svelte',
   'tailwindcss',
   'taplo',
   'tsserver',
   'vuels',
   'yamlls',
}
if HOST.is_win then
   table.insert(_G.DEFAULT_LSP_SERVERS, { 'powershell_es' })
end
