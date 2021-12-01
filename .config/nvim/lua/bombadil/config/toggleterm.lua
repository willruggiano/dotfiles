local toggleterm = require "toggleterm"

toggleterm.setup {}

require("which-key").register {
  ["<space><space>"] = {
    function()
      toggleterm.toggle_command("direction=float", 0)
    end,
    "terminal",
  },
}
