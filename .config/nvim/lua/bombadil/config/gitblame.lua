require("which-key").register {
  ["<leader>g"] = {
    b = { "<cmd>GitBlameToggle<cr>", "blame" },
  },
}
