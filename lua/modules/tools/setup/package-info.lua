local ucolours = require('utils.colours')
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
end

return M
