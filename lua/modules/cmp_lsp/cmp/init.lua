local cmp = require('cmp')
local icons = require('modules.ui.icons')
local luasnip = require('luasnip')

local has_words_before = function()
   if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
      return false
   end
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
end

vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#8cdb53' })
vim.api.nvim_set_hl(0, 'CmpItemKindEmoji', { fg = '#FDE030' })
vim.api.nvim_set_hl(0, 'CmpItemKindCrates', { fg = '#F64D00' })

cmp.setup({
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },

   sorting = {
      priority_weight = 2,
      comparators = {
         require('copilot_cmp.comparators').prioritize,
         require('copilot_cmp.comparators').score,
         cmp.config.compare.offset,
         cmp.config.compare.exact,
         cmp.config.compare.score,
         require('cmp-under-comparator').under,
         cmp.config.compare.recently_used,
         cmp.config.compare.locality,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order,
      },
   },

   formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
         vim_item.kind = icons.kind[vim_item.kind]

         if entry.source.name == 'copilot' then
            vim_item.kind = icons.custom.Octoface
            vim_item.kind_hl_group = 'CmpItemKindCopilot'
         end

         if entry.source.name == 'emoji' then
            vim_item.kind = icons.custom.Emoji
            vim_item.kind_hl_group = 'CmpItemKindEmoji'
         end

         if entry.source.name == 'crates' then
            vim_item.kind = icons.custom.Crates
            vim_item.kind_hl_group = 'CmpItemKindCrates'
         end

         vim_item.menu = ({
            nvim_lsp = '[LSP]',
            copilot = '[Copilot]',
            nvim_lua = '[Lua]',
            luasnip = '[Luasnip]',
            buffer = '[Buffer]',
            path = '[Path]',
            emoji = '[Emoji]',
            crates = '[Crates]',
         })[entry.source.name]
         return vim_item
      end,
   },

   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },

   sources = {
      { name = 'crates', group_index = 1 },
      { name = 'nvim_lsp', group_index = 1 },
      -- { name = 'nvim_lsp_signature_help', group_index = 2 },
      { name = 'copilot', max_item_count = 3, group_index = 2 },
      { name = 'nvim_lua', group_index = 2 },
      { name = 'luasnip', group_index = 3 },
      {
         name = 'spell',
         option = {
            keep_all_entries = false,
            enable_in_context = function()
               return require('cmp.config.context').in_treesitter_capture('spell')
            end,
         },
         group_index = 2,
      },
      { name = 'buffer', group_index = 2 },
      { name = 'path', group_index = 2 },
      { name = 'latex_symbols', group_index = 2 },
   },

   confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
   },

   experimental = {
      ghost_text = true,
   },

   mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
         i = cmp.mapping.abort(),
         c = cmp.mapping.close(),
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
         elseif luasnip.jumpable(1) then
            luasnip.jump(1)
         elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
         elseif has_words_before() then
            cmp.complete()
         else
            fallback()
         end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end, { 'i', 's' }),
   }),
})

cmp.setup.cmdline('/', {
   sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
   }, {
      { name = 'buffer' },
   }),
})

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = 'path' },
   }, {
      { name = 'cmdline' },
   }),
})
