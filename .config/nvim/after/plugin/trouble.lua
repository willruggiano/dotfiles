local ok, _ = pcall(require, "trouble")
if not ok then
  return
end
local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  ["<space>td"] = { "<cmd>TroubleToggle<cr>", "diagnostics" },
}
