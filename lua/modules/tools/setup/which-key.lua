local M = {}

M.opts = {
   plugins = { spelling = true },
   icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
   },
   popup_mappings = {
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
   },
   window = {
      border = 'rounded',
      position = 'bottom',
   },
   defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      ['gz'] = { name = '+surround' },
      ['gc'] = { name = '+comment' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader><tab>'] = { name = '+tabs' },
      ['<leader>b'] = { name = '+buffer' },
      -- ['<leader>c'] = { name = '+code' },
      ['<leader>f'] = { name = '+file/find' },
      ['<leader>g'] = { name = '+git' },
      ['<leader>gc'] = { name = '+checkout' },
      ['<leader>gd'] = { name = '+diff' },
      ['<leader>gh'] = { name = '+hunks' },
      ['<leader>gt'] = { name = '+toggle' },
      ['<leader>gr'] = { name = '+reset' },
      ['<leader>i'] = { name = '+icons' },
      ['<leader>q'] = { name = '+quit/session' },
      ['<leader>j'] = { name = '+split/join' },
      ['<leader>l'] = { name = '+lsp' },
      ['<leader>la'] = { name = '+actions' },
      ['<leader>ls'] = { name = '+show' },
      ['<leader>m'] = { name = '+mini-map' },
      ['<leader>n'] = { name = '+nvim-tree' },
      ['<leader>s'] = { name = '+search' },
      ['<leader>S'] = { name = '+search/replace' },
      ['<leader>t'] = { name = '+terminal' },
      ['<leader>w'] = { name = '+windows' },
      ['<leader>x'] = { name = '+diagnostics/quickfix' },
   },
   crates = {
      mode = { 'n', 'v' },
      ['<leader>p'] = '+crates',
      ['<leader>po'] = '+open',
      ['<leader>ps'] = '+show',
   },
   ['package-info'] = {
      mode = { 'n', 'v' },
      ['<leader>p'] = '+package-info',
   },
}

M.config = function(_, opts)
   local wk = require('which-key')
   wk.setup(opts)
   wk.register(opts.defaults)

   if package.loaded['crates'] then
      wk.register(opts.crates)
   end
   if package.loaded['package-info'] then
      wk.register(opts['package-info'])
   end
end

return M
