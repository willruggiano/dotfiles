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
      alt = { "N.B." },
      icon = icons.get "comment",
    },
  },
  search = {
    pattern = [[\b(KEYWORDS):?]],
  },
  signs = true,
}
