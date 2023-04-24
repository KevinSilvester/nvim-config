local M = {}

M.opts = {
   -- colors = {
   --    up_to_date = '#83a598', -- Text color for up to date dependency virtual text
   --    outdated = '#ce9322', -- Text color for outdated dependency virtual text
   -- },
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

return M
