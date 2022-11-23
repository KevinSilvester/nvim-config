local config = {}

config.nvim_lspconfig = function()
   require('modules.cmp_lsp.lsp')
end

config.cmp = function()
   require('modules.cmp_lsp.cmp')
end

config.copilot = function()
   require('modules.cmp_lsp.config._copilot')
end

config.fidget = function()
   require('modules.cmp_lsp.config._fidget')
end

config.lsp_signature = function()
   require('modules.cmp_lsp.config._lsp_signature')
end

config.lspsaga = function()
   require('modules.cmp_lsp.config._lspsaga')
end

config.luasnip = function()
   require('modules.cmp_lsp.config._luasnip')
end

config.mason = function()
   require('modules.cmp_lsp.config._mason')
end

config.mason_lspconfig = function()
   require('modules.cmp_lsp.config._mason_lspconfig')
end

config.null_ls = function()
   require('modules.cmp_lsp.config._null_ls')
end

config.nvim_autopairs = function()
   require('modules.cmp_lsp.config._nvim_autopairs')
end

config.nvim_navic = function()
   require('modules.cmp_lsp.config._nvim_navic')
end

return config
