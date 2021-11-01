local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local ok, _ = pcall(require, "nvim-cheat")
if not ok then
  return
end

wk.register {
  ["?"] = { "<cmd>Cheat<cr>", "cheat" },
}
