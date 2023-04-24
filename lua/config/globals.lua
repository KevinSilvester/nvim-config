local ufn = require('utils.fn')
local fn = vim.fn

vim.g.mapleader = ' '

------------------------------------------------------------------------
--                      colourscheme variation                        --
------------------------------------------------------------------------
vim.g.catppuccin_flavour = 'mocha'
vim.g.material_style = 'deep ocean'


------------------------------------------------------------------------
--                     PATH environment variable                      --
------------------------------------------------------------------------
vim.env.PATH = vim.env.PATH .. (HOST.is_win and ';' or ':') .. fn.stdpath('data') .. '/mason/bin'


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
