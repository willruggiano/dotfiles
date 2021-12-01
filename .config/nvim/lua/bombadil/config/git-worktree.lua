require("which-key").register {
  ["<leader>gw"] = {
    name = "worktree",
    c = {
      function()
        -- TODO: I don't like having to manually specify the path to the worktree.
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      "create",
    },
    l = {
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      "list",
    },
  },
}
