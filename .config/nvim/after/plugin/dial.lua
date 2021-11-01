local ok, dial = pcall(require, "dial")
if not ok then
  return
end

-- Toggle true/false
dial.augends["custom#boolean"] = dial.common.enum_cyclic {
  name = "boolean",
  strlist = { "true", "false" },
}
table.insert(dial.config.searchlist.normal, "custom#boolean")

dial.augends["custom#git#rebase"] = dial.common.enum_cyclic {
  name = "git#rebase",
  strlist = { "pick", "edit", "fixup", "reword", "squash", "drop" },
}
table.insert(dial.config.searchlist.normal, "custom#git#rebase")

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  ["<C-a>"] = {
    function()
      dial.cmd.increment_normal(vim.v.count1)
    end,
    "increment",
  },
  ["<C-x>"] = {
    function()
      dial.cmd.increment_normal(-vim.v.count1)
    end,
    "decrement",
  },
}
wk.register({
  ["<C-a>"] = {
    function()
      dial.cmd.increment_visual(vim.v.count1)
    end,
    "increment",
  },
  ["<C-x>"] = {
    function()
      dial.cmd.increment_visual(-vim.v.count1)
    end,
    "increment",
  },
}, {
  mode = "v",
})
