local wk = require('which-key')
local cmd = require('core.mapper').cmd

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

local opts = function(mode)
   return {
      mode = mode,
      prefix = '<leader>',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   }
end

local lua = function(cmd_str)
   return cmd('lua ' .. cmd_str)
end

-- which-key setup
wk.setup({
   key_labels = {
      ['<leader>'] = 'SPC',
   },
   icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
   },
   popup_mappings = {
      scroll_down = '<c-d>',
      scroll_up = '<c-u>',
   },
   window = {
      border = 'rounded',
      position = 'bottom',
   },
   layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = 'left',
   },
   ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
   triggers = { '<leader>' },
   triggers_blacklist = {
      i = { 'j', 'k' },
      v = { 'j', 'k' },
   },
})

local n_mappings = {
   ['e'] = { cmd('NvimTreeToggle'), 'Explorer' },
   ['q'] = { cmd('Bdelete!'), 'Close Buffer' },
   ['h'] = { cmd('nohlsearch'), 'Clear Highlights' },
   ['/'] = {
      name = 'Comment',
      ['/'] = { lua('require("Comment.api").toggle.linewise.current()'), 'Comment line' },
      b = { lua('require("Comment.api").toggle.blockwise.current()'), 'Comment blockwise' },
   },

   c = {
      name = 'Crates',
      t = { lua("require('crates').toggle()"), 'Toggle' },
      r = { lua("require('crates').reload()"), 'Reload' },
      v = { lua("require('crates').show_versions_popup()"), 'Show Versions' },
      f = { lua("require('crates').show_features_popup()"), 'Show Features' },
      d = { lua("require('crates').show_dependencies_popup()"), 'Show Dependencies' },
      u = { lua("require('crates').update_crate()"), 'Update Crate' },
      U = { lua("require('crates').update_crates()"), 'Update Crates' },
      a = { lua("require('crates').update_all_crates()"), 'Update All Crates' },
      H = { lua("require('crates').open_homepage()"), 'Open Homepage' },
      R = { lua("require('crates').open_repository()"), 'Open Repository' },
      D = { lua("require('crates').open_documentation()"), 'Open Documentation' },
      C = { lua("require('crates').open_crate_io()"), 'Open crates.io' },
   },

   p = {
      name = 'Packer',
      c = { cmd('PackerCompile'), 'Compile' },
      i = { cmd('PackerInstall'), 'Install' },
      s = { cmd('PackerSync'), 'Sync' },
      S = { cmd('PackerStatus'), 'Status' },
      u = { cmd('PackerUpdate'), 'Update' },
   },

   m = {
      name = 'Mini-Map',
      o = { cmd('Minimap'), 'Open' },
      c = { cmd('MinimapClose'), 'Close' },
      t = { cmd('MinimapToggle'), 'Toggle' },
      r = { cmd('MinimapRescan'), 'Rescan' },
      R = { cmd('MinimapRefresh'), 'Refresh' },
      u = { cmd('MinimapUpdateHighlight'), 'Update Highlight' },
   },

   d = {
      name = 'Debugger',
      b = { lua('require("dap").toggle_breakpoint()'), 'Toggle breakpoint' },
      c = { lua('require("dap").continue()'), 'Continue' },
      i = { lua('require("dap").step_into()'), 'Step into' },
      o = { lua('require("dap").step_over()'), 'Step over' },
      O = { lua('require("dap").step_out()'), 'Step out' },
      r = { lua('require("dap").repl.toggle()'), 'Toggle REPL' },
      l = { lua('require("dap").run_last()'), 'Run last' },
      u = { lua('require("dapui").toggle()'), 'Toggle UI' },
      t = { lua('require("dap").terminate()'), 'Terminate' },
   },

   g = {
      name = 'Git',
      j = { lua("require('gitsigns').next_hunk()"), 'Next Hunk' },
      k = { lua("require('gitsigns').prev_hunk()"), 'Prev Hunk' },
      l = { lua("require('gitsigns').blame_line()"), 'Blame' },
      p = { lua("require('gitsigns').preview_hunk()"), 'Preview Hunk' },
      r = { lua("require('gitsigns').reset_hunk()"), 'Reset Hunk' },
      R = { lua("require('gitsigns').reset_buffer()"), 'Reset Buffer' },
      s = { lua("require('gitsigns').stage_hunk()"), 'Stage Hunk' },
      S = { lua("require('gitsigns').stage_buffer()"), 'Stage Buffer' },
      u = {
         lua("require('gitsigns').undo_stage_hunk()"),
         'Undo Stage Hunk',
      },
      o = { cmd('Telescope git_status'), 'Open changed file' },
      b = { cmd('Telescope git_branches'), 'Checkout branch' },
      c = { cmd('Telescope git_commits'), 'Checkout commit' },
      d = {
         cmd('Gitsigns diffthis HEAD'),
         'Diff',
      },
   },

   l = {
      name = 'LSP',
      a = { cmd('Lspsaga code_action'), 'Code Action' },
      c = { lua("require('utils.lsp').server_capabilities()"), 'Get Capabilites' },
      f = { lua('vim.lsp.buf.format({ timeout_ms = 1000 })'), 'Format' },
      h = { lua('vim.lsp.buf.signature_help()'), 'Help' },
      i = { cmd('LspInfo'), 'LSP Info' },
      o = { cmd('LSoutlineToggle'), 'Document Symbols' },
      l = { lua('vim.lsp.codelens.run()'), 'CodeLens Action' },
      m = { cmd('Mason'), 'Mason' },
      q = { lua('vim.diagnostic.setloclist()'), 'All Diagnostics' },
      r = { lua('vim.lsp.buf.rename()'), 'Rename' },
   },

   s = {
      name = 'Search',
      f = { cmd('Telescope find_files'), 'Search File' },
      t = { cmd('Telescope live_grep '), 'Search Text' },
      b = { cmd('Telescope buffers'), 'Search Buffers' },
      B = { cmd('Telescope git_branches'), 'Checkout branch' },
      c = { cmd('Telescope colorscheme'), 'Show Colorschemes' },
      d = { cmd('Telescope diagnostics'), 'Search Diagnostics' },
      h = { cmd('Telescope help_tags'), 'Search Help' },
      n = { cmd('Telescope notify'), 'Search Notification' },
      r = { cmd('Telescope oldfiles'), 'Search Recent File' },
      k = { cmd('Telescope keymaps'), 'Search Keymaps' },
      C = { cmd('Telescope commands'), 'Search Commands' },
   },

   S = {
      name = 'Find/Replace',
      s = { lua("require('spectre').open_visual()"), 'Search and replace' },
      w = {
         lua("require('spectre').open_visual({ select_word = true })"),
         'Search current word and replace',
      },
      f = {
         lua("require('spectre').open_file_search()"),
         'Search current file and replace',
      },
   },

   t = {
      name = 'Terminal',
      -- n = { lua("_NODE_TOGGLE()"), "Node" },
      -- p = { lua("_PYTHON_TOGGLE()"), "Python" },
      f = { cmd('ToggleTerm direction=float'), 'Float' },
      h = { cmd('ToggleTerm size=10 direction=horizontal'), 'Horizontal' },
      v = { cmd('ToggleTerm size=80 direction=vertical'), 'Vertical' },
   },
}

local x_mappings = {
   ['/'] = {
      name = 'Comment',
      ['/'] = {
         function()
            vim.api.nvim_feedkeys(esc, 'nx', false)
            require('Comment.api').toggle.linewise(vim.fn.visualmode())
         end,
         'Comment linewise',
      },
      b = {
         function()
            vim.api.nvim_feedkeys(esc, 'nx', false)
            require('Comment.api').toggle.blockwise(vim.fn.visualmode())
         end,
         'Comment blockwise',
      },
   },
}

wk.register(n_mappings, opts('n'))
wk.register(x_mappings, opts('x'))
