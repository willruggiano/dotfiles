require("which-key").register {
  ["?"] = {
    function()
      require("nvim-cheat"):new_cheat(false)
    end,
    "cheat",
  },
}
