local execute = vim.api.nvim_command

require("marks").setup {}

require("which-key").register {
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
