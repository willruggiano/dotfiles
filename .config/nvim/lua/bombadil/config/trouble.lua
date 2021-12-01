require("trouble").setup {
  auto_preview = false,
  auto_fold = true,
}

require("which-key").register {
  ["<space>td"] = { "<cmd>TroubleToggle<cr>", "diagnostics" },
}
