if vim.fn.expand('%:t') ~= 'package.json' then
   return
end

local wk = require('which-key')
local m = require('core.mapper')

wk.register({ p = { name = '+package-info' } }, { prefix = '<leader>' })

-- stylua: ignore
m.buf_nmap(vim.api.nvim_get_current_buf(), {
   { '<leader>pt', require('package-info').toggle,         m.opts(m.silent, m.noremap, 'Toggle dependency versions'), },
   { '<leader>pu', require('package-info').update,         m.opts(m.silent, m.noremap, 'Update dependency'), },
   { '<leader>pd', require('package-info').delete,         m.opts(m.silent, m.noremap, 'Delete dependency'), },
   { '<leader>pi', require('package-info').install,        m.opts(m.silent, m.noremap, 'Install new dependency'), },
   { '<leader>pv', require('package-info').change_version, m.opts(m.silent, m.noremap, 'Change dependency version'), },
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave' }, {
   group = vim.api.nvim_create_augroup('ftplugin.json', { clear = true }),
   desc = 'Clear <leader>p which-key mappings',
   buffer = vim.api.nvim_get_current_buf(),
   callback = function(args)
      if args.event == 'BufEnter' then
         log:debug('ftplugin.json', 'Setting <leader>p mappings', true)
         wk.register({ p = { name = '+package-info' } }, { prefix = '<leader>' })
      end

      if args.event == 'BufLeave' then
         log:debug('ftplugin.json', 'Clearing <leader>p mappings', true)
         wk.register({ p = { name = '' } }, { prefix = '<leader>' })
      end
   end,
})
