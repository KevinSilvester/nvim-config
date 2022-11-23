local saga = require('lspsaga')
local icons = require('modules.ui.icons')
local colors = require('lspsaga.lspkind').colors

saga.init_lsp_saga({
   border_style = 'rounded',
   --the range of 0 for fully opaque window (disabled) to 100 for fully
   --transparent background. Values between 0-30 are typically most useful.
   saga_winblend = 0,
   -- when cursor in saga window you config these to move
   move_in_saga = { prev = '<C-p>', next = '<C-n>' },
   diagnostic_header = icons.diagnostics,
   -- preview lines above of lsp_finder
   preview_lines_above = 0,
   -- preview lines of lsp_finder and definition preview
   max_preview_lines = 20,
   code_action_icon = 'ﯧ ',
   -- if true can press number to execute the codeaction in codeaction window
   code_action_num_shortcut = true,
   -- same as nvim-lightbulb but async
   code_action_lightbulb = {
      enable = true,
      enable_in_insert = true,
      cache_code_action = false,
      sign = true,
      update_time = 150,
      sign_priority = 20,
      virtual_text = true,
   },
   -- finder icons
   finder_icons = {
      def = '  ',
      ref = '諭 ',
      link = '  ',
   },
   -- finder do lsp request timeout
   -- if your project big enough or your server very slow
   -- you may need to increase this value
   finder_request_timeout = 1500,
   finder_action_keys = {
      open = { 'o', '<CR>' },
      vsplit = 's',
      split = 'i',
      tabe = 't',
      quit = { 'q', '<ESC>' },
   },
   code_action_keys = {
      quit = { 'q', '<ESC>' },
      exec = '<CR>',
   },
   definition_action_keys = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>i',
      tabe = '<C-c>t',
      quit = { 'q', '<ESC>' },
   },
   rename_action_quit = '<C-c>',
   rename_in_select = true,
   symbol_in_winbar = {
      in_custom = false,
      enable = true,
      separator = '  ',
      show_file = true,
      file_formatter = '%:t',
      click_support = function(node, clicks, button, modifiers)
         -- To see all avaiable details: vim.pretty_print(node)
         local st = node.range.start
         local en = node.range['end']
         if button == 'l' then
            if clicks == 2 then
               -- double left click to do nothing
            else -- jump to node's starting line+char
               vim.fn.cursor(st.line + 1, st.character + 1)
            end
         elseif button == 'r' then
            if modifiers == 's' then
               print('lspsaga') -- shift right click to print "lspsaga"
            end -- jump to node's ending line+char
            vim.fn.cursor(en.line + 1, en.character + 1)
         elseif button == 'm' then
            -- middle click to visual select node
            vim.fn.cursor(st.line + 1, st.character + 1)
            vim.cmd('normal v')
            vim.fn.cursor(en.line + 1, en.character + 1)
         end
      end,
   },
   show_outline = {
      win_position = 'right',
      --set special filetype win that outline window split.like NvimTree neotree
      -- defx, db_ui
      win_with = '',
      win_width = 30,
      auto_enter = true,
      auto_preview = true,
      virt_text = '┃',
      jump_key = 'o',
      -- auto refresh when change buffer
      auto_refresh = true,
   },
   -- custom lsp kind
   custom_kind = {
      -- Kind
      Class = { icons.kind.Class .. " ", colors.yellow },
      Constant = { icons.kind.Constant .. " ", colors.peach },
      Constructor = { icons.kind.Constructor .. " ", colors.sapphire },
      Enum = { icons.kind.Enum .. " ", colors.yellow },
      EnumMember = { icons.kind.EnumMember .. " ", colors.teal },
      Event = { icons.kind.Event .. " ", colors.yellow },
      Field = { icons.kind.Field .. " ", colors.teal },
      File = { icons.kind.File .. " ", colors.rosewater },
      Function = { icons.kind.Function .. " ", colors.blue },
      Interface = { icons.kind.Interface .. " ", colors.yellow },
      Key = { icons.kind.Keyword .. " ", colors.red },
      Method = { icons.kind.Method .. " ", colors.blue },
      Module = { icons.kind.Module .. " ", colors.blue },
      Namespace = { icons.kind.Namespace .. " ", colors.blue },
      Number = { icons.kind.Number .. " ", colors.peach },
      Operator = { icons.kind.Operator .. " ", colors.sky },
      Package = { icons.kind.Package .. " ", colors.blue },
      Property = { icons.kind.Property .. " ", colors.teal },
      Struct = { icons.kind.Struct .. " ", colors.yellow },
      TypeParameter = { icons.kind.TypeParameter .. " ", colors.maroon },
      Variable = { icons.kind.Variable .. " ", colors.peach },
      -- Type
      Array = { icons.type.Array .. " ", colors.peach },
      Boolean = { icons.type.Boolean .. " ", colors.peach },
      Null = { icons.type.Null .. " ", colors.yellow },
      Object = { icons.type.Object .. " ", colors.yellow },
      String = { icons.type.String .. " ", colors.green },
      -- ccls-specific iconss .. " ".
      TypeAlias = { icons.kind.TypeAlias .. " ", colors.green },
      Parameter = { icons.kind.Parameter .. " ", colors.blue },
      StaticMethod = { icons.kind.StaticMethod .. " ", colors.peach },
   },
   server_filetype_map = {},
})
