if not packer_plugins['plenary.nvim'].loaded then
   vim.cmd([[packadd plenary.nvim]])
   vim.cmd([[packadd popup.nvim]])
   vim.cmd([[packadd telescope-fzf-native.nvim]])
end

local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local previewers_utils = require('telescope.previewers.utils')
local Job = require('plenary.job')

local preview_width = 60

local notify_error = function(msg)
   vim.notify(msg, vim.log.levels.ERROR, { title = 'Telescope Config' })
end

local custom_marker = function(filepath, bufnr, opts)
   filepath = vim.fn.expand(filepath)
   Job:new({
      command = 'file',
      args = { '--mime-type', '-b', filepath },
      on_stderr = function()
         notify_error("Error: command 'file' failed")
      end,
      on_exit = function(j)
         local mime_type = vim.split(j:result()[1], '/')[1]

         -- Display text using bat
         if mime_type == 'text' then
            previewers.buffer_previewer_maker(filepath, bufnr, opts)

            -- If on Windows, display images using viu as telescope media file extension requires ueberzug
            -- which is not available on Windows
         elseif mime_type == 'image' and HOST.is_win then
            vim.schedule(function()
               previewers_utils.set_preview_message(bufnr, opts.winid, 'Image Loading...')
               local term = vim.api.nvim_open_term(bufnr, {})
               local image_data

               Job:new({
                  command = 'viu',
                  args = { '-w', '40', '-b', filepath },
                  on_exit = function(j, _)
                     image_data = vim.split(j:result()[1], '\n')
                  end,
                  on_stderr = function()
                     notify_error("Error: command 'viu' failed")
                  end,
               }):sync()

               for _, d in ipairs(image_data) do
                  if d == '' then
                     goto continue
                  end
                  vim.api.nvim_chan_send(term, d .. '\r\n')
                  ::continue::
               end
            end)

            -- Don't display binary files
         else
            vim.schedule(function()
               previewers_utils.set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
            end)
         end
      end,
   }):sync()
end

require('telescope').setup({
   defaults = {
      prompt_prefix = '  ',
      selection_caret = ' ',
      -- buffer_previewer_maker = custom_marker,
      path_display = { 'truncate' },
      file_ignore_patterns = { 'node_modules', '^.git/' },
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
         '--glob',
         '!.git/*',
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
            '--path-separator',
            '/',
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
