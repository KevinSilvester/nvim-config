local which_key = require('which-key')
local cmd = require('core.mapper').cmd

-- stylua: ignore
local setup = {
   plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
         enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
         suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
         operators = false, -- adds help for operators like d, y,
         motions = true, -- adds help for motions
         text_objects = true, -- help for text objects triggered after entering an operator
         windows = true, -- default bindings on <c-w>
         nav = true, -- misc bindings to work with windows
         z = true, -- bindings for folds, spelling and others prefixed with z
         g = true, -- bindings for prefixed with g
      },
   },
   key_labels = {
      ['<leader>'] = 'SPC',
   },
   icons = {
      breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
      separator = '➜', -- symbol used between a key and it's label
      group = '+', -- symbol prepended to a group
   },
   popup_mappings = {
      scroll_down = '<c-d>', -- binding to scroll down inside the popup
      scroll_up = '<c-u>', -- binding to scroll up inside the popup
   },
   window = {
      border = 'rounded', -- none, single, double, shadow
      position = 'bottom', -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
   },
   layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = 'left', -- align columns left, center or right
   },
   ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
   hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
   triggers = { "<leader>" },
   triggers_blacklist = {
      i = { 'j', 'k' },
      v = { 'j', 'k' },
   },
}

local opts = {
   mode = 'n', -- NORMAL mode
   prefix = '<leader>',
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true, -- use `silent` when creating keymaps
   noremap = true, -- use `noremap` when creating keymaps
   nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
   ['e'] = { '<cmd>NvimTreeToggle<cr>', 'Explorer' },
   ['q'] = { '<cmd>Bdelete!<CR>', 'Close Buffer' },
   ['h'] = { '<cmd>nohlsearch<CR>', 'Clear Highlights' },
   ['/'] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', 'Comment line' },

   c = {
      name = 'Crates',
      t = { "<cmd>lua require('crates').toggle()<cr>", 'Toggle' },
      r = { "<cmd>lua require('crates').reload()<cr>", 'Reload' },
      v = { "<cmd>lua require('crates').show_versions_popup()<cr>", 'Show Versions' },
      f = { "<cmd>lua require('crates').show_features_popup()<cr>", 'Show Features' },
      d = { "<cmd>lua require('crates').show_dependencies_popup()<cr>", 'Show Dependencies' },
      u = { "<cmd>lua require('crates').update_crate()<cr>", 'Update Crate' },
      U = { "<cmd>lua require('crates').update_crates()<cr>", 'Update Crates' },
      a = { "<cmd>lua require('crates').update_all_crates()<cr>", 'Update All Crates' },
      H = { "<cmd>lua require('crates').open_homepage()<cr>", 'Open Homepage' },
      R = { "<cmd>lua require('crates').open_repository()<cr>", 'Open Repository' },
      D = { "<cmd>lua require('crates').open_documentation()<cr>", 'Open Documentation' },
      C = { "<cmd>lua require('crates').open_crate_io()<cr>", 'Open crates.io' },
   },

   p = {
      name = 'Packer',
      c = { '<cmd>PackerCompile<cr>', 'Compile' },
      i = { '<cmd>PackerInstall<cr>', 'Install' },
      s = { '<cmd>PackerSync<cr>', 'Sync' },
      S = { '<cmd>PackerStatus<cr>', 'Status' },
      u = { '<cmd>PackerUpdate<cr>', 'Update' },
   },

   m = {
      name = 'Mini-Map',
      o = { '<cmd>Minimap<CR>', 'Open' },
      c = { '<cmd>MinimapClose<CR>', 'Close' },
      t = { '<cmd>MinimapToggle<CR>', 'Toggle' },
      r = { '<cmd>MinimapRescan<CR>', 'Rescan' },
      R = { '<cmd>MinimapRefresh<CR>', 'Refresh' },
      u = { '<cmd>MinimapUpdateHighlight<CR>', 'Update Highlight' },
   },

   d = {
      name = 'Debugger',
      b = { '<cmd>lua require("dap").toggle_breakpoint()<cr>', 'Toggle breakpoint' },
      c = { '<cmd>lua require("dap").continue()<cr>', 'Continue' },
      i = { '<cmd>lua require("dap").step_into()<cr>', 'Step into' },
      o = { '<cmd>lua require("dap").step_over()<cr>', 'Step over' },
      O = { '<cmd>lua require("dap").step_out()<cr>', 'Step out' },
      r = { '<cmd>lua require("dap").repl.toggle()<cr>', 'Toggle REPL' },
      l = { '<cmd>lua require("dap").run_last()<cr>', 'Run last' },
      u = { '<cmd>lua require("dapui").toggle()<cr>', 'Toggle UI' },
      t = { '<cmd>lua require("dap").terminate()<cr>', 'Terminate' },
   },

   g = {
      name = 'Git',
      j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", 'Next Hunk' },
      k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", 'Prev Hunk' },
      l = { "<cmd>lua require('gitsigns').blame_line()<cr>", 'Blame' },
      p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", 'Preview Hunk' },
      r = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", 'Reset Hunk' },
      R = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", 'Reset Buffer' },
      s = { "<cmd>lua require('gitsigns').stage_hunk()<cr>", 'Stage Hunk' },
      S = { "<cmd>lua require('gitsigns').stage_buffer()<cr>", 'Stage Buffer' },
      u = {
         "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>",
         'Undo Stage Hunk',
      },
      o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
      b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
      c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
      d = {
         '<cmd>Gitsigns diffthis HEAD<cr>',
         'Diff',
      },
   },

   l = {
      name = 'LSP',
      a = { '<cmd>Lspsaga code_action<cr>', 'Code Action' },
      c = { "<cmd>lua require('utils.lsp').server_capabilities()<cr>", 'Get Capabilites' },
      f = { '<cmd>lua vim.lsp.buf.format({ timeout_ms = 1000 })<cr>', 'Format' },
      h = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Help' },
      i = { '<cmd>LspInfo<cr>', 'LSP Info' },
      o = { cmd('LSoutlineToggle'), 'Document Symbols' },
      l = { '<cmd>lua vim.lsp.codelens.run()<cr>', 'CodeLens Action' },
      m = { '<cmd>Mason<cr>', 'Mason' },
      q = { '<cmd>lua vim.diagnostic.setloclist()<cr>', 'All Diagnostics' },
      r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
   },

   s = {
      name = 'Search',
      f = { '<cmd>Telescope find_files<cr>', 'Find File' },
      t = { '<cmd>Telescope live_grep <cr>', 'Find Text' },
      b = { '<cmd>Telescope buffers<cr>', 'Find Buffer' },
      B = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
      c = { '<cmd>Telescope colorscheme<cr>', 'Show Colorschemes' },
      h = { '<cmd>Telescope help_tags<cr>', 'Find Help' },
      M = { '<cmd>Telescope man_pages<cr>', 'Find Man Pages' },
      n = { '<cmd>Telescope notify<cr>', 'Find Notification' },
      r = { '<cmd>Telescope oldfiles<cr>', 'Open Recent File' },
      k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
      C = { '<cmd>Telescope commands<cr>', 'Commands' },
   },

   S = {
      name = 'Find/Replace',
      s = { "<cmd>lua require('spectre').open_visual()<cr>", 'Search and replace' },
      w = {
         "<cmd>lua require('spectre').open_visual({ select_word = true })<cr>",
         'Search current word and replace',
      },
      f = {
         "<cmd>lua require('spectre').open_file_search()<cr>",
         'Search current file and replace',
      },
   },

   t = {
      name = 'Terminal',
      -- n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
      -- p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
      f = { '<cmd>ToggleTerm direction=float<cr>', 'Float' },
      h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'Horizontal' },
      v = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', 'Vertical' },
   },
}

which_key.setup(setup)
which_key.register(mappings, opts)
