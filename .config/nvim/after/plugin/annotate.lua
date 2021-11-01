local ok, wk = pcall(require, "which-key")
if not ok then
  return
end
local ok, annotate = pcall(require, "annotate")
if not ok then
  return
end

wk.register {
  ["<leader>a"] = {
    name = "annotate",
    a = { annotate.add, "add" },
    c = { annotate.clear, "clear" },
    l = { annotate.list, "list" },
    r = { annotate.remove, "remove" },
  },
}
