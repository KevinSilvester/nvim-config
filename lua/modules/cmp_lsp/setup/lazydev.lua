local M = {}

M.opts = {
   library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'wezterm-types', mods = { 'wezterm' } },
   },
   integrations = {
      -- lspconfig = false
   },
}

return M
