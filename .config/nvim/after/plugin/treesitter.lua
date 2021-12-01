local ok, unit = pcall(require, "treesitter-unit")
if not ok then
  return
end

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  ["<leader>t"] = {
    name = "toggle",
    h = {
      name = "highlight",
      u = {
        function()
          unit.toggle_highlighting()
        end,
        "unit",
      },
    },
    p = { ":TSPlaygroundToggle<cr>", "treesitter-playground" },
  },
}

wk.register({
  iu = {
    [[:lua require("treesitter-unit").select()<cr>]],
    "inner-unit",
  },
  au = {
    [[:lua require("treesitter-unit").select(true)<cr>]],
    "outer-unit",
  },
}, { mode = "x" })

wk.register({
  iu = {
    [[:<c-u>lua require("treesitter-unit").select()<cr>]],
    "inner-unit",
  },
  au = {
    [[:<c-u>lua require("treesitter-unit").select(true)<cr>]],
    "outer-unit",
  },
}, { mode = "o" })
