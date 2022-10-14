require('package-info').setup({
   -- colors = {
   --    up_to_date = '#83a598', -- Text color for up to date dependency virtual text
   --    outdated = '#ce9322', -- Text color for outdated dependency virtual text
   -- },
   icons = {
      enable = true, -- Whether to display icons
      style = {
         -- up_to_date = "|  ", -- Icon for up to date dependencies
         up_to_date = '   ', -- Icon for up to date dependencies
         outdated = '   ', -- Icon for outdated dependencies
      },
   },
   -- display the status of the package in the statusline
   autostart = true, -- Whether to autostart when `package.json` is opened
   hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
   hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
   package_manager = 'pnpm',
})
