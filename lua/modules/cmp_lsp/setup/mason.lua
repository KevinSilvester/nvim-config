local cmd = require('core.mapper').cmd
local M = {}

M.opts = {
   ui = {
      border = 'rounded',
      icons = {
         package_installed = '✓',
         package_pending = '➜',
         package_uninstalled = '✗',
      },
   },
   keymaps = {
      toggle_package_expand = '<CR>',
      install_package = 'i',
      update_package = 'u',
      check_package_version = 'c',
      update_all_packages = 'U',
      check_outdated_packages = 'C',
      uninstall_package = 'X',
      cancel_installation = '<C-c>',
      apply_language_filter = '<C-f>',
   },
   log_level = vim.log.levels.INFO,
   max_concurrent_installers = 4,
}

M.keys = {
   { '<leader>lm', cmd('Mason'), desc = 'Open Mason'}
}

return M
