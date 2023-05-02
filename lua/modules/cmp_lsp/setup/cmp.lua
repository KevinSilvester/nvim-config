local icons = require('modules.ui.icons')
local ucmp = require('utils.cmp')
local M = {}

M.opts = {
   completion = {
      ---@usage The minimum length of a word to complete on.
      keyword_length = 1,
   },
   experimental = {
      ghost_text = false,
      native_menu = false,
   },
   formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      max_width = 0,
      source_names = {
         nvim_lsp = '[LSP]',
         copilot = '[Copilot]',
         nvim_lua = '[Lua]',
         luasnip = '[Luasnip]',
         buffer = '[Buffer]',
         path = '[Path]',
         emoji = '[Emoji]',
         crates = '[Crates]',
         treesitter = '[TreeSitter]',
      },
      duplicates = {
         buffer = 1,
         path = 1,
         nvim_lsp = 0,
         luasnip = 1,
      },
      duplicates_default = 0,
   },
}

M.config = function(_, opts)
   local cmp = require('cmp')
   local cmp_types = require('cmp.types.cmp')
   local cmp_window = require('cmp.config.window')
   local cmp_mapping = require('cmp.config.mapping')
   local luasnip = require('luasnip')
   local ap_cmp = require('nvim-autopairs.completion.cmp')
   local ap_handlers = require('nvim-autopairs.completion.handlers')

   vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#8cdb53' })
   vim.api.nvim_set_hl(0, 'CmpItemKindEmoji', { fg = '#FDE030' })
   vim.api.nvim_set_hl(0, 'CmpItemKindCrates', { fg = '#F64D00' })

   opts.confirm_opts = {
      behavior = cmp_types.ConfirmBehavior.Replace,
      select = false,
   }

   -- cmp formatting
   opts.formatting.format = function(entry, vim_item)
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

      vim_item.menu = opts.formatting.source_names[entry.source.name]
      vim_item.dup = opts.formatting.duplicates[entry.source.name] or opts.formatting.duplicates_default

      return vim_item
   end

   -- cmp snippets
   opts.snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   }

   -- cmp window
   opts.window = {
      completion = cmp_window.bordered(),
      documentation = cmp_window.bordered(),
   }

   -- cmp sources
   opts.sources = {
      {
         name = 'copilot',
         max_item_count = 3,
         -- stylua: ignore
         trigger_characters = {
            { '.', ':', '(', "'", '"', '[', ',', '#', '*', '@', '|', '=', '-', '{', '/', '\\', '+', '?', ' ', }, },
      },
      {
         name = 'nvim_lsp',
         entry_filter = function(entry, _)
            local kind = require('cmp.types.lsp').CompletionItemKind[entry:get_kind()]
            if kind == 'Text' or kind == 'Snippet' then
               return false
            end
            return true
         end,
      },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      {
         name = 'spell',
         option = {
            keep_all_entries = false,
            enable_in_context = function()
               return require('cmp.config.context').in_treesitter_capture('spell')
            end,
         },
      },
      { name = 'emoji' },
      { name = 'treesitter' },
      { name = 'crates' },
   }

   -- cmp mapping
   opts.mapping = cmp_mapping.preset.insert({
      ['<C-k>'] = cmp_mapping(cmp_mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-j>'] = cmp_mapping(cmp_mapping.select_next_item(), { 'i', 'c' }),
      ['<Down>'] = cmp_mapping(
         cmp_mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }),
         { 'i' }
      ),
      ['<Up>'] = cmp_mapping(
         cmp_mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }),
         { 'i' }
      ),
      ['<C-d>'] = cmp_mapping.scroll_docs(-4),
      ['<C-f>'] = cmp_mapping.scroll_docs(4),
      ['<C-y>'] = cmp_mapping({
         i = cmp_mapping.confirm({ behavior = cmp_types.ConfirmBehavior.Replace, select = false }),
         c = function(fallback)
            if cmp.visible() then
               cmp.confirm({ behavior = cmp_types.ConfirmBehavior.Replace, select = false })
            else
               fallback()
            end
         end,
      }),
      ['<Tab>'] = cmp_mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
         elseif ucmp.jumpable(1) then
            luasnip.jump(1)
         elseif ucmp.has_words_before() then
            -- cmp.complete()
            fallback()
         else
            fallback()
         end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp_mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end, { 'i', 's' }),
      ['<C-Space>'] = cmp_mapping.complete(),
      ['<C-e>'] = cmp_mapping.abort(),
      ['<CR>'] = cmp_mapping(function(fallback)
         if cmp.visible() then
            local confirm_opts = vim.deepcopy(opts.confirm_opts)
            if ucmp.is_insert_mode() then -- prevent overwriting brackets
               confirm_opts.behavior = cmp_types.ConfirmBehavior.Insert
            end
            local entry = cmp.get_selected_entry()
            local is_copilot = entry and entry.source.name == 'copilot'
            if is_copilot then
               confirm_opts.behavior = cmp_types.ConfirmBehavior.Replace
               confirm_opts.select = true
            end
            if cmp.confirm(confirm_opts) then
               return -- success, exit early
            end
         end
         fallback() -- if not exited early, always fallback
      end),
   })

   cmp.setup(opts)

   cmp.event:on(
      'confirm_done',
      ap_cmp.on_confirm_done({
         filetypes = {
            ['*'] = {
               ['('] = {
                  kind = {
                     cmp.lsp.CompletionItemKind.Function,
                     cmp.lsp.CompletionItemKind.Method,
                  },
                  handler = ap_handlers['*'],
               },
            },
            tex = false,
         },
      })
   )
end

return M
