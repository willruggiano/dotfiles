local icons = require "nvim-nonicons"

require("todo-comments").setup {
  keywords = {
    FIX = {
      icon = icons.get "bug",
    },
    TODO = {
      icon = icons.get "tasklist",
    },
    HACK = {
      icon = icons.get "flame",
    },
    WARN = {
      icon = icons.get "alert",
    },
    PERF = {
      icon = icons.get "stopwatch",
    },
    NOTE = {
      -- HACK: No trailing "." for the alternate to make the highlighting visually consistent
      alt = { "N.B" },
      icon = icons.get "comment",
    },
  },
  highlight = {
    pattern = [[.*<(KEYWORDS)[.:]{1}]],
  },
  search = {
    pattern = [[\b(KEYWORDS)[.:]{1}]],
  },
  signs = true,
}
