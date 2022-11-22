local wilder = require("wilder")

wilder.setup({ modes = { ":", "/", "?" } })

wilder.set_option(
   "renderer",
   wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      highlights = { border = "Normal" },
      border = "rounded",
      highlighter = wilder.basic_highlighter(),
      pumblend = 0,
      left = { " ", wilder.popupmenu_devicons() },
      right = { " ", wilder.popupmenu_scrollbar() },
   }))
)
