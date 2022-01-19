local gitsigns = require "gitsigns"

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
  },

  -- Can't decide if I like this or not :)
  numhl = false,
  keymaps = {},
}

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register({
  ["]c"] = {
    "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
    "Next hunk",
  },
  ["[c"] = {
    "&diff ? ']c' : '<cmd>Gitsigns prev_hunk<CR>'",
    "Previous hunk",
  },
}, { expr = true })

wk.register {
  ["<leader>h"] = {
    name = "hunk",
    s = {
      "<cmd>Gitsigns stage_hunk<cr>",
      "stage",
    },
    u = {
      "<cmd>Gitsigns undo_stage_hunk<cr>",
      "unstage",
    },
    r = {
      "<cmd>Gitsigns reset_hunk<cr>",
      "reset",
    },
    R = {
      "<cmd>Gitsigns reset_buffer<cr>",
      "reset-buffer",
    },
    p = {
      "<cmd>Gitsigns preview_hunk<cr>",
      "preview",
    },
    b = {
      function()
        gitsigns.blame_line { full = true }
      end,
      "blame",
    },
    S = {
      "<cmd>Gitsigns stage_buffer<cr>",
      "stage",
    },
    U = {
      "<cmd>Gitsigns reset_buffer_index<cr>",
      "reset-buffer-index",
    },
  },
}

wk.register({
  ["<leader>h"] = {
    name = "hunk",
    s = {
      ":Gitsigns stage_hunk<cr>",
      "stage",
    },
    r = {
      ":Gitsigns reset_hunk<cr>",
      "reset",
    },
  },
}, { mode = "v" })

wk.register({
  ["ih"] = {
    ":<c-u>Gitsigns select_hunk<cr>",
    "hunk",
  },
}, { mode = "o" })

wk.register({
  ["ih"] = {
    ":<c-u>Gitsigns select_hunk<cr>",
    "hunk",
  },
}, { mode = "x" })
