local i = require('modules.ui.icons')

local kinds = {}

for k, v in pairs(i.kind) do
   kinds[k] = v .. ' '
end

---@type table<string, snacks.picker.layout.Config>
local layouts = {}

layouts.select_preview = {
   layout = {
      box = 'horizontal',
      backdrop = false,
      width = 0.65,
      min_width = 110,
      height = 0.5,
      min_height = 25,
      border = 'none',
      {
         box = 'vertical',
         {
            win = 'input',
            height = 1,
            border = 'rounded',
            title = '{title} {live} {flags}',
            title_pos = 'center',
         },
         { win = 'list', title = ' Results ', title_pos = 'center', border = 'rounded' },
      },
      {
         win = 'preview',
         title = '{preview:Preview}',
         width = 0.45,
         border = 'rounded',
         title_pos = 'center',
      },
   },
}

layouts.vscode_preview = vim.tbl_deep_extend('force', layouts.select_preview, { layout = { row = 5 } })

---@type snacks.picker.Config|{}
return {
   enabled = true,
   prompt = '  ',
   matcher = {
      frecency = true,
   },

   layouts = layouts,

   -- TODO: Create custom source for:
   -- sources = {
   --    vim_options = {},
   --    yanky = {},
   --    nvim_scissor = {},
   --    git_worktree = {},
   -- },

   sources = { explorer = { debug = { scores = false } } },

   ---@type snacks.picker.icons|{}
   icons = {
      -- stylua: ignore
      tree = {
         vertical = '│ ',
         middle   = '├╴',
         last     = '╰╴',
      },

      undo = { saved = ' ' },

      ui = {
         live = '󰐰 ',
         hidden = 'h',
         ignored = 'i',
         follow = 'f',
         selected = '● ',
         unselected = '○ ',
         -- selected = " ",
      },

      git = {
         enabled = true, -- show git icons
         commit = '󰜘 ', -- used by git log
         staged = i.git.Staged, -- staged changes. always overrides the type icons
         added = i.git.Add,
         deleted = i.git.Remove,
         ignored = i.git.Ignore,
         modified = i.git.Mod,
         renamed = i.git.Rename,
         unmerged = i.git.Unmerged,
         untracked = i.git.Untracked,
      },

      diagnostics = {
         Error = i.diagnostics.Error .. ' ',
         Warning = i.diagnostics.Warning .. ' ',
         Hint = i.diagnostics.Hint .. ' ',
         Info = i.diagnostics.Info .. ' ',
      },

      kinds = kinds,
   },

   debug = {
      scores = true,
   },
}
