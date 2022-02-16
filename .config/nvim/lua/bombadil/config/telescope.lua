require("which-key").register {
  ["<space>d"] = {
    function()
      require("telescope").extensions.dotfiles.dotfiles()
    end,
    "dotfiles",
  },
  ["<space>e"] = {
    function()
      require("telescope.builtin").git_files()
    end,
    "git-files",
  },
  ["<space>p"] = {
    function()
      require("telescope").extensions.project.project {}
    end,
    "projects",
  },
  ["<leader>gh"] = {
    name = "hub",
    g = {
      function()
        require("telescope").extensions.gh.gist()
      end,
      "gists",
    },
    i = {
      function()
        require("telescope").extensions.gh.issues()
      end,
      "issues",
    },
    p = {
      function()
        require("telescope").extensions.gh.pull_request()
      end,
      "pull-requests",
    },
    w = {
      function()
        require("telescope").extensions.gh.run()
      end,
      "workflows",
    },
  },
}
