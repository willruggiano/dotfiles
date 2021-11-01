local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local ok, _ = pcall(require, "harpoon")
if not ok then
  return
end

wk.register {
  ["<space>q"] = { require("harpoon.ui").toggle_quick_menu, "quickmenu" },
  ["<space>m"] = {
    name = "mark",
    f = { require("harpoon.mark").add_file, "file" },
  },
}

for i = 1, 5 do
  wk.register {
    ["<space>" .. i] = {
      function()
        require("harpoon.ui").nav_file(i)
      end,
      ("goto-file-" .. i),
    },
  }
end
