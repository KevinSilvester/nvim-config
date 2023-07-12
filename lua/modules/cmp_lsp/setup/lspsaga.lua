local cmd = require('core.mapper').cmd
local kind = require('modules.ui.icons').kind
local M = {}

M.opts = {
   ui = {
      theme = 'round',
      border = 'rounded',
      title = true,
      winblend = 0,
      expand = '',
      collapse = '',
      preview = ' ',
      code_action = 'ﯧ ',
      diagnostic = 'ﯧ ',
      incoming = ' ',
      outgoing = ' ',
      colors = {
         --float window normal bakcground color
         normal_bg = '#1d1536',
         --title background color
         title_bg = '#afd700',
      },
      -- stylua: ignore
      kind = {
         Array         = { kind.Array .. ' ', 'Type' },
         Boolean       = { kind.Boolean .. ' ', 'Boolean' },
         File          = { kind.File .. ' ', 'Tag' },
         Module        = { kind.Module .. ' ', 'Exception' },
         Namespace     = { kind.Namespace .. ' ', 'Include' },
         Package       = { kind.Package .. ' ', 'Label' },
         Class         = { kind.Class .. ' ', 'Include' },
         Method        = { kind.Method .. ' ', 'Function' },
         Property      = { kind.Property .. ' ', '@property' },
         Field         = { kind.Field .. ' ', '@field' },
         Constructor   = { kind.Constructor .. ' ', '@constructor' },
         Enum          = { kind.Enum .. ' ', '@number' },
         Interface     = { kind.Interface .. ' ', 'Type' },
         Function      = { kind.Function .. ' ', 'Function' },
         Variable      = { kind.Variable .. ' ', '@variable' },
         Constant      = { kind.Constant .. ' ', 'Constant' },
         String        = { kind.String .. ' ', 'String' },
         Number        = { kind.Number .. ' ', 'Number' },
         Object        = { kind.Object .. ' ', 'Type' },
         Key           = { kind.Key .. ' ', '' },
         Null          = { kind.Null .. ' ', 'Constant' },
         EnumMember    = { kind.EnumMember .. ' ', 'Number' },
         Struct        = { kind.Struct .. ' ', 'Type' },
         Event         = { kind.Event .. ' ', 'Constant' },
         Operator      = { kind.Operator .. ' ', 'Operator' },
         TypeParameter = { kind.TypeParameter .. ' ', 'Type' },
         TypeAlias     = { kind.TypeAlias .. ' ', 'Type' },
         Parameter     = { kind.Parameter .. ' ', '@parameter' },
         StaticMethod  = { kind.StaticMethod .. ' ', 'Function' },
         Macro         = { kind.Macro .. ' ', 'Macro' },
         Text          = { kind.Text .. ' ', 'String' },
         Snippet       = { kind.Snippet .. ' ', '@variable' },
         Folder        = { kind.Folder .. ' ', 'Title' },
         Unit          = { kind.Unit .. ' ', 'Number' },
         Value         = { kind.Value .. ' ', '@variable' },
      },
   },
   diagnostic = {
      show_code_action = true,
      show_source = true,
      jump_num_shortcut = true,
      keys = {
         exec_action = 'o',
         quit = 'q',
         go_action = 'g',
      },
   },
   code_action = {
      num_shortcut = true,
      keys = {
         quit = 'q',
         exec = '<CR>',
      },
   },
   lightbulb = {
      enable = true,
      enable_in_insert = true,
      cache_code_action = false,
      sign = true,
      sign_priority = 40,
      virtual_text = false,
   },
   preview = {
      lines_above = 0,
      lines_below = 20,
   },
   scroll_preview = {
      scroll_down = '<C-p>',
      scroll_up = '<C-n>',
   },
   request_timeout = 2000,
   finder = {
      edit = { 'o', '<CR>' },
      vsplit = 's',
      split = 'i',
      tabe = 't',
      quit = { 'q', '<ESC>' },
   },
   definition = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>i',
      tabe = '<C-c>t',
      quit = 'q',
      close = '<Esc>',
   },
   rename = {
      quit = '<C-c>',
      exec = '<CR>',
      mark = 'x',
      confirm = '<CR>',
      in_select = true,
   },
   symbol_in_winbar = {
      enable = false,
      separator = '  ',
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
      respect_root = false,
      color_mode = true,
   },
   outline = {
      win_position = 'right',
      win_with = '',
      win_width = 30,
      show_detail = true,
      auto_preview = true,
      auto_refresh = true,
      auto_close = true,
      custom_sort = nil,
      keys = {
         jump = 'o',
         expand_collapse = 'u',
         quit = 'q',
      },
   },
   callhierarchy = {
      show_detail = false,
      keys = {
         edit = 'e',
         vsplit = 's',
         split = 'i',
         tabe = 't',
         jump = 'o',
         quit = 'q',
         expand_collapse = 'u',
      },
   },
   server_filetype_map = {},
}

-- stylua: ignore
M.keys = {
   { '<leader>lac', cmd('Lspsaga code_action'),           desc = 'Code Action' },
   { '<leader>ld',  cmd('Lspsaga show_line_diagnostics'), desc = 'Show Line Diagnostics' },
   { '<leader>lsd', cmd('Lspsaga peek_definition'),       desc = 'Show Definitions' },
   { '<leader>lso', cmd('Lspsaga outline'),               desc = 'Show Document Symbols' },
   { '<leader>lsr', cmd('Lspsaga lsp_finder'),            desc = 'Show References' },
}

return M
