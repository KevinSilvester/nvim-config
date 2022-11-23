local utils = require('core.utils')
local fn = vim.fn


------------------------------------------------------------------------
--                          custom variables                          --
------------------------------------------------------------------------
vim.g.is_win = (vim.loop.os_uname().sysname == 'Windows_NT') and true or false
vim.g.is_linux = (vim.loop.os_uname().sysname == 'Linux') and true or false
vim.g.is_mac = (vim.loop.os_uname().sysname == 'Darwin') and true or false
vim.g.is_docker = vim.fn.filereadable('/.dockerenv') == 1
vim.g.catppuccin_flavour = 'mocha'
vim.g.material_style = 'deep ocean'


------------------------------------------------------------------------
--                      PATH environment variable                     --
------------------------------------------------------------------------
vim.env.PATH = vim.env.PATH .. (vim.g.is_win and ';' or ':') .. fn.stdpath('data') .. '/mason/bin'


------------------------------------------------------------------------
--                          filetype loader                           --
------------------------------------------------------------------------
-- if utils.is_latest() then
--    vim.g.did_load_filetypes = 1
--    vim.g.do_filetype_lua = 1
-- end


------------------------------------------------------------------------
--                    clipboard in WSL and MacOS                      --
------------------------------------------------------------------------
if utils.has('wsl') and not vim.g.is_docker then
   vim.g.clipboard = {
      copy = {
         ['+'] = 'win32yank.exe -i --crlf',
         ['*'] = 'win32yank.exe -i --crlf',
      },
      paste = {
         ['+'] = 'win32yank.exe -o --lf',
         ['*'] = 'win32yank.exe -o --lf',
      },
      cache_enabled = 0,
   }
end

if vim.g.is_mac then
   vim.g.clipboard = {
      name = 'macOS-clipboard',
      copy = {
         ['+'] = 'pbcopy',
         ['*'] = 'pbcopy',
      },
      paste = {
         ['+'] = 'pbpaste',
         ['*'] = 'pbpaste',
      },
      cache_enabled = 0,
   }
end


------------------------------------------------------------------------
--                           python host                              --
------------------------------------------------------------------------
if vim.g.is_win and utils.executable('scoop') then
   vim.g.python_host_prog = fn.expand('~/scoop/apps/python/current/python.exe')
   vim.g.python3_host_prog = fn.expand('~/scoop/shims/python3.exe')
end

if vim.g.is_linux then
   local has_brew = utils.executable('brew')
   vim.g.python_host_prog = '/usr/bin/python'
   vim.g.python3_host_prog = has_brew and '/home/linuxbrew/.linuxbrew/bin/python3' or '/usr/bin/python3'
end

if vim.g.is_mac then
   vim.g.python_host_prog = '/usr/bin/python'
   vim.g.python3_host_prog = '/usr/local/bin/python3'
end


------------------------------------------------------------------------
--                         neovide options                            --
------------------------------------------------------------------------
if fn.exists('g:neovide') then
   vim.g.neovide_refresh_rate = 60
   vim.g.neovide_transparancey = 1
   vim.g.neovide_fullscreen = false
   vim.g.neovide_remember_window_size = true
end


------------------------------------------------------------------------
--                         minimap options                            --
------------------------------------------------------------------------
vim.g.minimap_width = 20
vim.g.minimap_auto_start = 0
vim.g.minimap_auto_start_win_enter = 0
vim.g.minimap_highlight_range = 0
vim.g.minimap_git_colors = 1


------------------------------------------------------------------------
--                  disable distribution plugins                      --
------------------------------------------------------------------------
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1


------------------------------------------------------------------------
--                           lsp servers                              --
------------------------------------------------------------------------
vim.g.lsp_servers = {
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
if vim.g.is_win then
   vim.list_extend(vim.g.lsp_servers, { 'powershell_es' })
end

-- vim.g.lsp_servers = {
--    "astro-language-server",
--    "awk-language-server",
--    "bash-langauge-server",
--    "clang-format",
--    "clangd",
--    "cmake-language-server",
--    "codelldb",
--    "css-lsp",
--    "dockerfile-language-server",
--    "dot-langauge-server",
--    "emmet-ls",
--    "eslint-lsp",
--    "flake8",
--    "gopls",
--    "graphql-language-service-cli",
--    "html-lsp",
--    "json-lsp",
--    "kotlin-language-server",
--    "lua-language-server",
--    "prettier",
--    "prisma-language-server",
--    "pyright",
--    "rust-analyzer",
--    "sqls",
--    "stylua",
--    "svelte-langauge-server",
--    "tailwindcss-langauge-server",
--    "taplo",
--    "typescript-langauge-server",
--    "vetur-vls",
--    "vue-language-server",
--    "yamlls",
-- }
