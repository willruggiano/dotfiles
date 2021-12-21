vim.bo.shiftwidth = 2
vim.bo.textwidth = 100

local ok, _ = pcall(require, "luadev")
if not ok then
  return
end

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register({
  ["<leader><leader>r"] = {
    name = "run",
    l = { "<Plug>(Luadev-RunLine)", "line" },
    o = { "<Plug>(Luadev-Run)", "operator" },
    w = { "<Plug>(Luadev-RunWord)", "word" },
  },
}, { buffer = 0 })

wk.register({
  ["<leader><leader>r"] = { "<Plug>(Luadev-Run)", "run" },
}, { buffer = 0, mode = "v" })
