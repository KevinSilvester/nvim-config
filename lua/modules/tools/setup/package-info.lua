local ucolours = require('utils.colours')
local m = require('core.mapper')
local M = {}

M.opts = {
   icons = {
      enable = true,
      style = {
         up_to_date = '   ',
         outdated = '   ',
      },
   },
   autostart = true,
   hide_up_to_date = false,
   hide_unstable_versions = false,
   package_manager = 'pnpm',
}

M.config = function(_, opts)
   require('package-info').setup(opts)
   require('telescope').load_extension('package_info')

   vim.api.nvim_set_hl(0, 'PackageInfoUpToDateVersion', ucolours.get_hl('DiagnosticVirtualTextInfo'))
   vim.api.nvim_set_hl(0, 'PackageInfoOutdatedVersion', ucolours.get_hl('DiagnosticVirtualTextWarn'))

   -- stylua: ignore
   m.nmap({
      { '<leader>pt', require('package-info').toggle,         m.opts(m.silent, m.noremap, 'Toggle dependency versions'), },
      { '<leader>pu', require('package-info').update,         m.opts(m.silent, m.noremap, 'Update dependency'), },
      { '<leader>pd', require('package-info').delete,         m.opts(m.silent, m.noremap, 'Delete dependency'), },
      { '<leader>pi', require('package-info').install,        m.opts(m.silent, m.noremap, 'Install new dependency'), },
      { '<leader>pv', require('package-info').change_version, m.opts(m.silent, m.noremap, 'Change dependency version'), },
   })
end

return M
