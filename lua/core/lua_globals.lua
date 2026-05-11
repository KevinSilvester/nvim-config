-- stylua: ignore start

------------------------------------------------------------------------
--                            host OS                                 --
------------------------------------------------------------------------
_G.HOST = {}
HOST.is_win = vim.uv.os_uname().sysname == 'Windows_NT'
HOST.is_linux = vim.uv.os_uname().sysname == 'Linux'
HOST.is_mac = vim.uv.os_uname().sysname == 'Darwin'
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
   'biome',
   'cmake',
   'cssls',
   'css_variables',
   -- 'denols',
   'dockerls',
   'docker_compose_language_service',
   'emmet_ls',
   -- 'eslint',
   'html',
   'jsonls',
   'lua_ls',
   -- 'omnisharp',
   'pyright',
   -- 'rust_analyzer', rustaceanvim get confused between this and ls that comes with the rust toolchain
   'sqlls',
   'svelte',
   'tailwindcss',
   'taplo',
   'ts_ls',
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
-- _G.HARPOON_LIST = {}
-- stylua: ignore end
