local icons = {}

-- stylua: ignore
icons.diagnostics = {
   Error   = "",
   Warning = "",
   Hint    = "󰌵",
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
   Untracked = "U",
   Unmerged  = "",
   Staged    = "S",
   Unstaged  = "",
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
   Array         = "",
   Boolean       = "",
   Class         = "",
   Color         = "󰏘",
   Constant      = "",
   Constructor   = "",
   Enum          = "",
   EnumMember    = "",
   Event         = "",
   Field         = "",
   File          = "",
   Folder        = "",
   Function      = "󰊕",
   Interface     = "",
   Key           = "",
   Keyword       = "",
   Macro         = "",
   Method        = "󰆧",
   Module        = "",
   Namespace     = "",
   Null          = "",
   Number        = "",
   Object        = "󰅩",
   Operator      = "",
   Package       = "",
   Parameter     = "",
   Property      = "",
   Reference     = "",
   Snippet       = "",
   String        = "",
   Struct        = "",
   Variable      = "",
   Text          = "󰉿",
   TypeParameter = "",
   Unit          = "",
   Value         = "",
   StaticMethod  = "",
   TypeAlias     = "",
}

-- stylua: ignore
icons.custom = {
   Octoface = "",
   Emoji    = "󰞅",
   Crates   = "",
   Tree     = "",
}

-- stylua: ignore
icons.type = {
   Array   = "",
   Number  = "󰎠",
   String  = "󰉿",
   Boolean = "",
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
   Location        = ""
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

return icons
