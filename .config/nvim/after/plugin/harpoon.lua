local wk = require "which-key"

wk.register {
  ["<space>q"] = { require("harpoon.ui").toggle_quick_menu, "quickmenu" },
  ["<space>m"] = {
    name = "mark",
    f = { require("harpoon.mark").add_file, "file" },
  },
}
