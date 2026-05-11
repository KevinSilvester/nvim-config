local ufn = require('utils.fn')
local fn = vim.fn

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.editorconfig = true


------------------------------------------------------------------------
--                     PATH environment variable                      --
------------------------------------------------------------------------
vim.env.PATH = vim.env.PATH .. (HOST.is_win and ';' or ':') .. fn.stdpath('data') .. '/mason/bin'


------------------------------------------------------------------------
--                    clipboard in WSL and MacOS                      --
------------------------------------------------------------------------
if ufn.has('wsl') and not HOST.is_docker then
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

if HOST.is_mac then
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
if HOST.is_win and ufn.executable('scoop') then
   vim.g.python_host_prog = fn.expand('~/scoop/apps/python/current/python.exe')
   vim.g.python3_host_prog = fn.expand('~/scoop/shims/python3.exe')
end

if HOST.is_linux then
   local has_brew = ufn.executable('brew')
   vim.g.python_host_prog = '/usr/bin/python'
   vim.g.python3_host_prog = has_brew and '/home/linuxbrew/.linuxbrew/bin/python3' or '/usr/bin/python3'
end

if HOST.is_mac then
   vim.g.python_host_prog = '/usr/bin/python'
   vim.g.python3_host_prog = '/usr/local/bin/python3'
end


------------------------------------------------------------------------
--                         neovide options                            --
------------------------------------------------------------------------
if vim.g.neovide then
   vim.g.neovide_refresh_rate = 165
   vim.g.neovide_transparancey = 1
   vim.g.neovide_fullscreen = false
   vim.g.neovide_remember_window_size = true
end


------------------------------------------------------------------------
--                  disable distribution plugins                      --
------------------------------------------------------------------------
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_matchparen = 1
