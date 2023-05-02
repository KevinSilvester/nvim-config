local m = require('core.mapper')
local M = {}

M.opts = {
   popup = {
      autofocus = true,
      style = 'minimal',
      border = 'rounded',
      show_version_date = false,
      show_dependency_version = true,
      max_height = 30,
      min_width = 20,
      padding = 1,
   },
   null_ls = {
      enabled = true,
      name = 'crates.nvim',
   },
}

M.config = function(_, opts)
   require('crates').setup(opts)

   -- stylua: ignore
   m.nmap({
      { '<leader>poh', require('crates').open_homepage,           m.opts(m.silent, m.noremap, 'Open Homepage') },
      { '<leader>por', require('crates').open_repository,         m.opts(m.silent, m.noremap, 'Open Repository') },
      { '<leader>pod', require('crates').open_documentation,      m.opts(m.silent, m.noremap, 'Open Documentation') },
      { '<leader>poc', require('crates').open_crates_io,          m.opts(m.silent, m.noremap, 'Open crates.io') },
      { '<leader>pr',  require('crates').reload,                  m.opts(m.silent, m.noremap, 'Reload Data') },
      { '<leader>psd', require('crates').show_dependencies_popup, m.opts(m.silent, m.noremap, 'Show Dependencies'), },
      { '<leader>psi', require('crates').show_crate_popup,        m.opts(m.silent, m.noremap, 'Show Details'), },
      { '<leader>psf', require('crates').show_features_popup,     m.opts(m.silent, m.noremap, 'Show Features'), },
      { '<leader>psv', require('crates').show_versions_popup,     m.opts(m.silent, m.noremap, 'Show Versions'), },
      { '<leader>pt',  require('crates').toggle,                  m.opts(m.silent, m.noremap, 'Toggle virtual text'), },
      { '<leader>pu',  require('crates').update_crate,            m.opts(m.silent, m.noremap, 'Update Crate') },
      { '<leader>pU',  require('crates').update_all_crates,       m.opts(m.silent, m.noremap, 'Update all Crates'), },
   })
end

return M
