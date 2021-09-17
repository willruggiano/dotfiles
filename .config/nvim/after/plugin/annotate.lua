local wk = require "which-key"

wk.register {
  ["<leader>a"] = {
    name = "annotate",
    a = {
      function()
        require("annotate").add()
      end,
      "add",
    },
    c = {
      function()
        require("annotate").clear()
      end,
      "clear",
    },
    l = {
      function()
        require("annotate").list()
      end,
      "list",
    },
    r = {
      function()
        require("annotate").remove()
      end,
      "remove",
    },
  },
}
