local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

-- Better buffer naviation.
wk.register {
  ["<tab>"] = { "<cmd>bnext<cr>", ":bnext" },
  ["<s-tab>"] = { "<cmd>bprev<cr>", ":bprev" },
}
