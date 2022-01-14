local themes = require "bombadil.telescope.themes"

require("which-key").register {
  ["<space>d"] = {
    function()
      require("telescope").extensions.dotfiles.dotfiles()
    end,
    "dotfiles",
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
      "gist",
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
      "pull-request",
    },
    w = {
      function()
        require("telescope").extensions.gh.run()
      end,
      "workflows",
    },
  },
}
