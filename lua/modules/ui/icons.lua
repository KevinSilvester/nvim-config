local icons = {}

-- stylua: ignore
icons.diagnostics = {
   Error   = "",
   Warning = "",
   Hint    = "",
   Info    = "",
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
   Unix = "",         -- ebc6
   Mac  = "",         -- e302
   Dos  = "",         -- e70f
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
   File          = "",
   Module        = "",
   Namespace     = " ",
   Package       = "",
   Class         = "",
   Method        = "",
   Field         = "ﰠ",
   Constructor   = "",
   Enum          = "練",
   Interface     = "",
   Function      = "",
   Variable      = "",
   Constant      = "",
   String        = "",
   Text          = "",
   Number        = "",
   Boolean       = "",
   Array         = "",
   Object        = "",
   Key           = "",
   Keyword       = "",
   Null          = " ",
   EnumMember    = "練",
   Struct        = "",
   Property      = "",
   Event         = "",
   Operator      = "",
   TypeParameter = "",
   Unit          = "",
   Value         = "",
   Snippet       = "",
   Color         = "",
   Reference     = "",
   Folder        = "",
   -- ccls-specific icons.
   TypeAlias     = "",
   Parameter     = "",
   StaticMethod  = "",
   Macro         = "",
}

-- stylua: ignore
icons.custom = {
   Octoface = "",
   Emoji    = "ﲃ",
   Crates   = "",
   Tree     = "",
}

-- stylua: ignore
icons.type = {
   Array   = "",
   Number  = "",
   String  = "",
   Boolean = "蘒",
   Object  = "",
   Null    = " ",
}

icons.misc = {}

-- stylua: ignore
icons.dap = {
   Breakpoint           = '',
   BreakpointCondition  = 'ﳁ',
   BreakpointRejected   = '',
   LogPoint             = '',
   Pause                = '',
   Play                 = '',
   RunLast              = '↻',
   StepBack             = '',
   StepInto             = '',
   StepOut              = '',
   StepOver             = '',
   Stopped              = '',
   Terminate            = 'ﱢ',
}

return icons
