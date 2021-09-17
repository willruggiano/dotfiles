local wk = require "which-key"

wk.register {
  ["<space>t"] = {
    name = "toggle",
    o = { require("symbols-outline").toggle_outline, "outline" },
  },
}
