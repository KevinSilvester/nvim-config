local uv = vim.version().minor >= 10 and vim.uv or vim.loop
-- stylua: ignore start

------------------------------------------------------------------------
--                            host OS                                 --
------------------------------------------------------------------------
_G.HOST = {}
HOST.is_win = uv.os_uname().sysname == 'Windows_NT'
HOST.is_linux = uv.os_uname().sysname == 'Linux'
HOST.is_mac = uv.os_uname().sysname == 'Darwin'
HOST.is_docker = vim.fn.filereadable('/.dockerenv') == 1


------------------------------------------------------------------------
--                         standard paths                             --
------------------------------------------------------------------------
_G.PATH = {}
---@type string
---@diagnostic disable-next-line: assign-type-mismatch
PATH.config = vim.fn.stdpath('config')

---@type string
---@diagnostic disable-next-line: assign-type-mismatch
PATH.data = vim.fn.stdpath('data')

---@type string
---@diagnostic disable-next-line: assign-type-mismatch
PATH.cache = vim.fn.stdpath('cache')


------------------------------------------------------------------------
--                           lsp servers                              --
------------------------------------------------------------------------
_G.DEFAULT_LSP_SERVERS = {
   'astro',
   'bashls',
   'cmake',
   'cssls',
   'dockerls',
   'dotls',
   'emmet_ls',
   'eslint',
   'html',
   'jsonls',
   'pyright',
   'rust_analyzer',
   'sqlls',
   'svelte',
   'tailwindcss',
   'taplo',
   'tsserver',
   'yamlls',
}
if not HOST.is_docker then
   table.insert(_G.DEFAULT_LSP_SERVERS, 'lua_ls')
end
if HOST.is_win then
   table.insert(_G.DEFAULT_LSP_SERVERS, 'powershell_es')
end


------------------------------------------------------------------------
--                           harpoon list                             --
------------------------------------------------------------------------
---@type table<string, number>
_G.HARPOON_LIST = {}
-- stylua: ignore end
