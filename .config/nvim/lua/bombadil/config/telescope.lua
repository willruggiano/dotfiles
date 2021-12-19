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
}
