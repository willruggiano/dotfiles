local ok, marks = pcall(require, "marks")
if not ok then
  return
end

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local execute = vim.api.nvim_command

wk.register {
  ["<leader>b"] = {
    name = "bookmarks",
    l = {
      function()
        execute "BookmarksListAll"
      end,
      "list",
    },
  },
  ["<leader>m"] = {
    name = "marks",
    b = {
      function()
        execute "MarksListBuf"
      end,
      "list-buffer",
    },
    l = {
      function()
        execute "MarksListAll"
      end,
      "list",
    },
  },
}
