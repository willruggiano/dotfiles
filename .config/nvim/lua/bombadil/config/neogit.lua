local neogit = require "neogit"

neogit.setup {
  integrations = {
    diffview = true,
  },
}

require("which-key").register {
  ["<leader>g"] = {
    name = "git",
    s = { neogit.open, "status" },
    c = {
      function()
        neogit.open { "commit" }
      end,
      "commit",
    },
  },
}
