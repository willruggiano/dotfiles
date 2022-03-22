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

local noremap = require("bombadil.lib.keymap").noremap
local nnoremap = require("bombadil.lib.keymap").nnoremap

local nmappings = {
  ["]c"] = {
    [[&diff ? "]c" : "<cmd>Gitsigns next_hunk<cr>"]],
    { desc = "Next hunk", expr = true },
  },
  ["[c"] = {
    [[&diff ? "[c" : "<cmd>Gitsigns prev_hunk<cr>"]],
    { desc = "Previous hunk", expr = true },
  },
  ["<leader>hb"] = {
    function()
      gitsigns.blame_line { full = true }
    end,
    { desc = "Blame line" },
  },
  ["<leader>hR"] = {
    "<cmd>Gitsigns reset_buffer<cr>",
    { desc = "Reset buffer" },
  },
  ["<leader>hp"] = {
    "<cmd>Gitsigns preview_hunk<cr>",
    { desc = "Preview hunk" },
  },
  ["<leader>hS"] = {
    "<cmd>Gitsigns stage_buffer<cr>",
    { desc = "Stage buffer" },
  },
  ["<leader>hu"] = {
    "<cmd>Gitsigns undo_stage_hunk<cr>",
    { desc = "Unstage hunk" },
  },
  ["<leader>hU"] = {
    "<cmd>Gitsigns reset_buffer_index<cr>",
    { desc = "Reset buffer index" },
  },
}

for key, opts in pairs(nmappings) do
  nnoremap(key, opts[1], opts[2])
end

local nvmappings = {
  ["<leader>hs"] = {
    "<cmd>Gitsigns stage_hunk<cr>",
    { desc = "Stage hunk" },
  },
  ["<leader>hr"] = {
    "<cmd>Gitsigns reset_hunk<cr>",
    { desc = "Reset hunk" },
  },
}

for key, opts in pairs(nvmappings) do
  noremap({ "n", "v" }, key, opts[1], opts[2])
end

noremap({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", { desc = "hunk" })
