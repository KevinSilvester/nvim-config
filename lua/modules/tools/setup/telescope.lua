local cmd = require('core.mapper').cmd
local ufn = require('utils.fn')
local M = {}

M.config = function()
   local actions = require('telescope.actions')
   local previewers = require('telescope.previewers')
   local previewers_utils = require('telescope.previewers.utils')
   local Job = require('plenary.job')

   local preview_width = 60
   local function capture(cmd, raw)
      local f = assert(io.popen(cmd, 'r'))
      local s = assert(f:read('*a'))
      f:close()
      if raw then
         return s
      end
      s = string.gsub(s, '^%s+', '')
      s = string.gsub(s, '%s+$', '')
      s = string.gsub(s, '[\n\r]+', ' ')
      return s
   end

   local preview_maker = function(filepath, bufnr, opts)
      filepath = vim.fn.expand(filepath)
      -- Job:new({
      --    command = 'file',
      --    args = { '--mime-type', '-b', filepath },
      --    on_stderr = function()
      --       log.error('modules.tools.telescope', "Command 'file' failed")
      --    end,
      --    on_exit = function(j)
      --       local mime_type = vim.split(j:result()[1], '/')

      --       if mime_type[1] == 'text' or mime_type[2] == 'json' then
      --          previewers.buffer_previewer_maker(filepath, bufnr, opts)
      --       elseif mime_type[1] == 'image' then
      --          vim.schedule(function()
      --             previewers_utils.set_preview_message(bufnr, opts.winid, 'Image Loading...')
      --             local term = vim.api.nvim_open_term(bufnr, {})
      --             local image_data

      --             Job:new({
      --                command = 'viu',
      --                args = { '-w', '40', '-b', filepath },
      --                on_exit = function(i, _)
      --                   image_data = vim.split(i:result()[1], '\n')
      --                end,
      --                on_stderr = function()
      --                   log.error('modules.tools.telescope', "Command 'viu' failed")
      --                end,
      --             }):sync()

      --             for _, d in ipairs(image_data) do
      --                if d == '' then
      --                   goto continue
      --                end
      --                vim.api.nvim_chan_send(term, d .. '\r\n')
      --                ::continue::
      --             end
      --          end)

      --          -- Don't display binary files
      --       else
      --          vim.schedule(function()
      --             previewers_utils.set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
      --          end)
      --       end
      --    end,
      -- }):sync()
      -- ufn.spawn('file', { '--mime-type', '-b', filepath }, function(data)
      --    local mime_type = vim.split(data, '/')

      --    if mime_type[1] == 'text' or mime_type[2] == 'json' or mime_type[2]:find('svg') then
      --       log.debug('telescope64', mime_type)
      --       previewers.buffer_previewer_maker(filepath, bufnr, opts)
      --    elseif mime_type[1] == 'image' then
      --       log.debug('telescope67', mime_type)
      --       previewers_utils.set_preview_message(bufnr, opts.winid, 'Image Loading...')
      --       ufn.spawn('viu', { '-w', '50', '-b', filepath }, function(image_data)
      --          local term = vim.api.nvim_open_term(bufnr, {})
      --          local image_rows = vim.split(image_data, '\n')

      --          log.debug('telescope', image_rows)

      --          for _, block in ipairs(image_rows) do
      --             if block == '' then
      --                goto continue
      --             end
      --             vim.api.nvim_chan_send(term, block .. '\r\n')
      --             ::continue::
      --          end
      --       end, function()
      --          previewers_utils.set_preview_message(bufnr, opts.winid, 'Preview Maker Failed!')
      --       end)
      --    else
      --       log.debug('telescope86', mime_type)
      --       previewers_utils.set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
      --    end
      -- end, function()
      --    previewers_utils.set_preview_message(bufnr, opts.winid, 'Preview Maker Failed!')
      -- end)
      local mime_type = vim.split(capture(string.format([[file --mime-type -b "%s"]], filepath)), '/')

      opts.preview.check_mime_type = false
      -- if mime_type[1] == 'text' or mime_type[2] == 'json' or mime_type[2]:find('svg') then
      --    log.debug('telescope109', { mime_type, filepath })
      --    if filepath:find('swcrc') then
      --       opts.use_ft_detect = false
      --       opts.ft = 'json'
      --    end
      --    log.debug('telescope', opts)
      --    previewers.buffer_previewer_maker(filepath, bufnr, opts)
      -- end

      -- if mime_type[1] == 'image' then
         log.debug('telescope112', { mime_type, filepath })
         previewers_utils.set_preview_message(bufnr, opts.winid, 'Image Loading...')
         local image_data = vim.split(capture(string.format([[viu -b -w 50 "%s"]], filepath)), '/')
         local term = vim.api.nvim_open_term(bufnr, {})
         local image_rows = vim.split(image_data, '\n')
         log.debug('telescope', image_rows)
         for _, block in ipairs(image_rows) do
            if block == '' then
               goto continue
            end
            vim.api.nvim_chan_send(term, block .. '\r\n')
            ::continue::
         end
      -- else
      --    log.debug('telescope131', mime_type)
      --    previewers_utils.set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
      -- end
   end

   require('telescope').setup({
      defaults = {
         prompt_prefix = '  ',
         selection_caret = ' ',
         -- buffer_previewer_maker = preview_maker,
         path_display = { 'truncate' },
         file_ignore_patterns = { 'node_modules', '^.git/', 'target' },
         sorting_strategy = 'ascending',
         layout_strategy = 'horizontal',
         layout_config = {
            width = 0.75,
            preview_cutoff = 120,
            horizontal = {
               prompt_position = 'top',
               preview_width = function(_, cols, _)
                  preview_width = (cols < 120) and math.floor(cols * 0.5) or math.floor(cols * 0.6)
                  return preview_width
               end,
               mirror = false,
            },
            vertical = { mirror = false },
         },
         vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/*',
         },
         set_env = { ['COLORTERM'] = 'truecolor' },
         border = {},
         mappings = {
            i = {
               ['<Down>'] = actions.cycle_history_next,
               ['<Up>'] = actions.cycle_history_prev,
               ['<C-j>'] = actions.move_selection_next,
               ['<C-k>'] = actions.move_selection_previous,
            },
            n = { ['q'] = actions.close },
         },
         file_previewer = require('telescope.previewers').vim_buffer_cat.new,
         grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
         qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      },
      pickers = {
         find_files = {
            hidden = true,
            find_command = {
               'rg',
               '--files',
               '--color=never',
               '--no-heading',
               '--line-number',
               '--column',
               '--smart-case',
               '--hidden',
               '--glob',
               '!{.git/*,.svelte-kit/*,target/*,node_modules/*}',
            },
         },
         live_grep = {
            --@usage don't include the filename in the search results
            only_sort_text = true,
         },
         buffers = {
            sort_lastused = true,
            theme = 'dropdown',
            previewer = false,
            mappings = {
               i = {
                  ['<C-d>'] = 'delete_buffer',
               },
               n = {
                  ['<C-d>'] = 'delete_buffer',
               },
            },
         },
         colorscheme = { enable_preview = true },
      },
      extensions = {
         fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
         },
      },
   })
   require('telescope').load_extension('fzf')
   require('telescope').load_extension('notify')
end

M.keys = {
   { '<leader>ff', cmd('Telescope find_files'), desc = 'Files' },
   { '<leader>fb', cmd('Telescope buffers'), desc = 'Buffers' },
   { '<leader>fB', cmd('Telescope buffers show_all_buffers=true'), desc = 'Switch Buffer' },
   { '<leader>ft', cmd('Telescope live_grep'), desc = 'Text' },
   { '<leader>fw', cmd('Telescope grep_string'), desc = 'Word' },
   { '<leader>fr', cmd('Telescope oldfiles'), desc = 'Recent File' },
   -- git
   { '<leader>gc', cmd('Telescope git_commits'), desc = 'Checkout Commit' },
   { '<leader>go', cmd('Telescope git_status'), desc = 'Open Changed File' },
   { '<leader>gs', cmd('Telescope git_branch'), desc = 'Checkout Branch' },
   -- search
   { '<leader>sa', cmd('Telescope autocommands'), desc = 'Auto Commands' },
   { '<leader>sb', cmd('Telescope current_buffer_fuzzy_find'), desc = 'Buffer' },
   { '<leader>sC', cmd('Telescope command_history'), desc = 'Command History' },
   { '<leader>sc', cmd('Telescope commands'), desc = 'Commands' },
   {
      '<leader>sd',
      cmd('Telescope diagnostics bufnr=0'),
      desc = 'Document diagnostics',
   },
   {
      '<leader>sD',
      cmd('Telescope diagnostics'),
      desc = 'Workspace diagnostics',
   },
   { '<leader>sh', cmd('Telescope help_tags'), desc = 'Help Tags' },
   {
      '<leader>sH',
      cmd('Telescope highlights'),
      desc = 'Search Highlight Groups',
   },
   { '<leader>sk', cmd('Telescope keymaps'), desc = 'Key Maps' },
   { '<leader>sM', cmd('Telescope man_pages'), desc = 'Man Pages' },
   { '<leader>sm', cmd('Telescope marks'), desc = 'Jump to Mark' },
   { '<leader>so', cmd('Telescope vim_options'), desc = 'Options' },
   { '<leader>sR', cmd('Telescope resume'), desc = 'Resume' },
   {
      '<leader>sp',
      require('utils.fn').telescope('colorscheme', { enable_preview = true }),
      desc = 'Colorscheme with preview',
   },
}

return M
