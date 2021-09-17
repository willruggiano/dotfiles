local wk = require "which-key"

-- Better buffer naviation.
wk.register {
  ["<tab>"] = { "<cmd>bnext<cr>", ":bnext" },
  ["<s-tab>"] = { "<cmd>bprev<cr>", ":bprev" },
}
