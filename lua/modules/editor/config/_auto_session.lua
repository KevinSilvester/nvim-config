require('auto-session').setup({
   log_level = 'info',
   auto_session_enable_last_session = true,
   auto_session_root_dir = vim.fn.stdpath('cache') .. '/session',
   auto_session_enabled = true,
   auto_save_enabled = true,
   auto_restore_enabled = true,
   auto_session_suppress_dirs = nil,
})
