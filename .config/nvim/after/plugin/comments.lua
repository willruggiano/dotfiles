local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  ["<leader>c"] = {
    name = "comment",
    k = { "<Plug>kommentary_insert_above", "above" },
    j = { "<Plug>kommentary_insert_below", "below" },
  },
}
