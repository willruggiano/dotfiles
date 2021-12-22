local toggleterm = require "toggleterm"

toggleterm.setup {}

require("which-key").register {
  ["<space><space>"] = {
    function()
      -- TODO: Compute size based on window dimensions
      toggleterm.toggle_command("size=20", vim.v.count)
    end,
    "terminal",
  },
}
