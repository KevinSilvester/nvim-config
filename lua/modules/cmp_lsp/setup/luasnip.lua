local M = {}

M.config = function()
   require('luasnip').config.setup({
      history = true,
      enable_autosnippets = true,
      updateevents = 'TextChanged,TextChangedI',
   })

   require('luasnip.loaders.from_lua').lazy_load()
   require('luasnip.loaders.from_vscode').lazy_load()
   require('luasnip.loaders.from_vscode').lazy_load({ paths = { PATH.config .. '/snippets' } })
   require('luasnip.loaders.from_snipmate').lazy_load()
end

return M
