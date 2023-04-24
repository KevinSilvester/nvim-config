local fn = vim.fn

------------------------------------------------------------------------
--                            host OS                                 --
------------------------------------------------------------------------
_G.HOST = {}
HOST.is_win = vim.loop.os_uname().sysname == 'Windows_NT'
HOST.is_linux = vim.loop.os_uname().sysname == 'Linux'
HOST.is_mac = vim.loop.os_uname().sysname == 'Darwin'
HOST.is_docker = fn.filereadable('/.dockerenv') == 1

------------------------------------------------------------------------
--                         standard paths                             --
------------------------------------------------------------------------
_G.PATH = {}
PATH.config = vim.fn.stdpath('config')
PATH.data = vim.fn.stdpath('data')
PATH.cache = vim.fn.stdpath('cache')

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
   'sqlls',
   'lua_ls',
   'svelte',
   'tailwindcss',
   'taplo',
   'tsserver',
   'vuels',
   'yamlls',
}
if HOST.is_win then
   table.insert(_G.DEFAULT_LSP_SERVERS, 'powershell_es')
end

------------------------------------------------------------------------
--                        treesitter parsers                          --
------------------------------------------------------------------------
_G.DEFAULT_TREESITTER_PARSERS = {
   'bash',
   'comment',
   'css',
   'dockerfile',
   'fish',
   'git_config',
   'git_rebase',
   'gitattributes',
   'gitcommit',
   'gitignore',
   'graphql',
   'help',
   'html',
   'javascript',
   'jsdoc',
   'json',
   'jsonc',
   'lua',
   'make',
   'markdown',
   'markdown_inline',
   'python',
   'regex',
   'rust',
   'scss',
   'sql',
   'svelte',
   'toml',
   'vim',
   'yaml',
}
