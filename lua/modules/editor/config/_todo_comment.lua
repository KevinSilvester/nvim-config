require('todo-comments').setup({
   signs = true, -- show icons in the signs column
   sign_priority = 8, -- sign priority
   -- keywords recognized as todo comments
   keywords = {
      FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      TEST = { icon = 'ﭧ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
   },
   gui_style = {
      fg = 'BOLD', -- The gui style to use for the fg highlight group.
      bg = 'NONE', -- The gui style to use for the bg highlight group.
   },
   merge_keywords = true, -- when true, custom keywords will be merged with the defaults
   -- highlighting of the line containing the todo comment
   -- * before: highlights before the keyword (typically comment characters)
   -- * keyword: highlights of the keyword
   -- * after: highlights after the keyword (todo text)
   highlight = {
      before = '', -- "fg" or "bg" or empty
      keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = 'fg', -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = { 'markdown' }, -- list of file types to exclude highlighting
   },
   colors = {
      error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
      warning = { 'DiagnosticWarning', 'WarningMsg', '#FBBF24' },
      info = { 'DiagnosticInfo', '#2563EB' },
      hint = { 'DiagnosticHint', '#10B981' },
      default = { 'Identifier', '#7C3AED' },
      test = { 'Identifier', '#FF00FF' },
   },
   search = {
      command = 'rg',
      args = {
         '--color=never',
         '--no-heading',
         '--with-filename',
         '--line-number',
         '--column',
      },
      -- regex that will be used to match keywords.
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
   },
})
