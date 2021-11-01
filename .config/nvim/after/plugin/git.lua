local ok, _ = pcall(require, "colorbuddy")
if not ok then
  return
end

local c = require("colorbuddy.color").colors
local Group = require("colorbuddy.group").Group

Group.new("GitSignsAdd", c.green)
Group.new("GitSignsChange", c.yellow)
Group.new("GitSignsDelete", c.red)

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

gitsigns.setup {
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

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
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

local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end
local ok, _ = pcall(require, "gitblame")
if not ok then
  return
end

wk.register {
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
