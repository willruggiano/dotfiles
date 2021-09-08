local wk = require "which-key"

wk.register {
  ["<space><space>"] = {
    ":ToggleTerm direction=float<cr>",
    "terminal",
  },
}
