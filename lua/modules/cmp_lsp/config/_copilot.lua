require('copilot').setup({
   panel = {
      enabled = false,
   },
   ft_disable = { 'markdown' },
   plugin_manager_path = vim.fn.stdpath('data') .. '/site/pack/packer',
   copilot_node_command = 'node',
   server_opts_overrides = {
      trace = 'verbose',
      settings = {
         advanced = {
            listCount = 10, -- #completions for panel
            inlineSuggestCount = 3, -- #completions for getCompletions
         },
      },
   },
})
