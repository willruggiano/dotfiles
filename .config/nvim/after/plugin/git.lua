require "colorbuddy"

local c = require("colorbuddy.color").colors
local Group = require("colorbuddy.group").Group

Group.new("GitSignsAdd", c.green)
Group.new("GitSignsChange", c.yellow)
Group.new("GitSignsDelete", c.red)

require("gitsigns").setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
  },

  -- Can't decide if I like this or not :)
  numhl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
  },
}

require("which-key").register {
  ["<space>h"] = {
    name = "git-hunk",
    n = { "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'", expr = true, "next" },
    p = { "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'", expr = true, "previous" },
  },
  ["<space>tg"] = {
    name = "git",
    m = { "<plug>(git-messenger)", "messenger" },
  },
}

local neogit = require "neogit"

require("which-key").register {
  ["<leader>g"] = {
    name = "git",
    b = { "<cmd>GitBlameToggle<cr>", "blame" },
    s = { neogit.open, "status" },
    c = {
      function()
        neogit.open { "commit" }
      end,
      "commit",
    },
  },
}
