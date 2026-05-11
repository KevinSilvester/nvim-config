local icons = {}

-- stylua: ignore
icons.diagnostics = {
   Error   = "",
   Warning = "",
   Hint    = "󰛨",
   Info    = "",
}

-- stylua: ignore
icons.notify = {
   ERROR = "󰅚",
   WARN  = "",
   INFO  = "󰋽",
   DEBUG = '',
   TRACE = '✎',
}

-- stylua: ignore
icons.git = {
   Add       = "",
   Mod       = "",
   Remove    = "",
   Ignore    = "",
   Rename    = "",
   Copy      = "󰆏",
   Untracked = "?",
   Unmerged  = "",
   Staged    = "●",
   Unstaged  = "○",
   Branch    = "",
}

-- stylua: ignore
icons.os = {
   Unix = "", -- ebc6
   Mac  = "", -- e302
   Dos  = "", -- e70f
}

-- stylua: ignore
icons.fs = {
   DirClosed      = "",
   DirOpen        = "",
   DirEmptyClosed = "",
   DirEmptyOpen   = "",
   DirSymlink     = "",
   File           = "",
   FileSymlink    = "",
   Exec           = "",
   Unknown        = "",
   Bookmark       = ''
}

-- stylua: ignore
icons.kind = {
   Array            = "󰅪",
   BlockMappingPair = "",
   Boolean          = "󰨙",
   Class            = "",
   Color            = "",
   Control          = "",
   Collapsed        = " ",
   Constant         = "",
   Constructor      = "",
   Declaration      = "󰙠",
   DoStatement      = "󰑖",
   Enum             = "",
   EnumMember       = "",
   Event            = "",
   Field            = "",
   File             = "",
   Folder           = "󰉋",
   ForStatement     = "󰑖",
   Function         = "󰊕",
   GoToStatement    = "󱞶",
   Identifier       = "󰀫",
   IfStatement      = "󰇉",
   Interface        = "",
   Key              = "󰌋",
   Keyword          = "󰌋",
   List             = "󰅪",
   Macro            = "",
   Method           = "󰊕",
   Module           = "",
   Namespace        = "",
   Null             = "󰢤",
   Number           = "󰎠",
   Object           = "󰅩",
   Operator         = "",
   Package          = "",
   Parameter        = "",
   Property         = "",
   Reference        = "",
   Snippet          = "",
   StaticMethod     = "",
   String           = "",
   Struct           = "",
   SwitchStatement  = "󰺟",
   Text             = "",
   Type             = "",
   TypeAlias        = "",
   TypeParameter    = "",
   Unit             = "",
   Unknown          = "",
   Value            = "",
   Variable         = "󰀫",
   WhileStatement   = "󰑖",
}

-- stylua: ignore
icons.custom = {
   Octoface = "",
   Emoji    = "󰞅",
   Crates   = "",
   Tree     = "",
   Tailwind = "󱏿",
   Square   = "󰝤",
}

-- stylua: ignore
icons.type = {
   Array   = "",
   Number  = "󰎠",
   String  = "",
   Boolean = "󰨙",
   Object  = "󰅩",
   Null    = "",
}

-- stylua: ignore
icons.misc = {
   Ghost           = "󰊠",
   SemiCircleLeft  = "",
   SemiCircleRight = "",
   Info            = "󰋼",
   Formatter       = "󰉢",
   LSP             = "",
   FileSize        = "",
   Location        = "",
   Fire            = "󰈸",
   ArrowRight      = "",
   CaretRight      = "",
   CaretDown       = "",
   ThumbUp         = "",
   ThumbDown       = ""
}

-- stylua: ignore
icons.dap = {
   Breakpoint          = '󰝥',
   BreakpointCondition = '󰟃',
   BreakpointRejected  = '',
   LogPoint            = '',
   Pause               = '',
   Play                = '',
   RunLast             = '↻',
   StepBack            = '',
   StepInto            = '󰆹',
   StepOut             = '󰆸',
   StepOver            = '󰆷',
   Stopped             = '',
   Terminate           = '󰝤',
}

-- stylua: ignore
icons.todo = {
   Fix  = "",
   Todo = "",
   Hack = "",
   Warn = "",
   Perf = "󰅒",
   Note = "󰍨",
   Test = "󰙨",
}

return icons
