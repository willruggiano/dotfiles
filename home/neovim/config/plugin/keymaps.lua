local wk = require "which-key"
local inoremap = vim.keymap.inoremap
local nnoremap = vim.keymap.nnoremap
local tnoremap = vim.keymap.tnoremap

local list_loaded_buffers = require("bombadil.lib.buffers").list_loaded_buffers

-- WhichKey doesn't seem to like these
-- Opens line above or below the current line
-- TODO(2021-09-13,wruggian): These don't seem to take for some reason...
inoremap { "<c-cr>", "<c-o>O" }
inoremap { "<s-cr>", "<c-o>o" }

-- Better pane navigation
nnoremap { "<c-j>", "<c-w><c-j>" }
nnoremap { "<c-k>", "<c-w><c-k>" }
nnoremap { "<c-h>", "<c-w><c-h>" }
nnoremap { "<c-l>", "<c-w><c-l>" }

-- Scrolling
nnoremap { "<up>", "<c-y>" }
nnoremap { "<down>", "<c-e>" }

-- Tab nagivation
nnoremap { "<right>", "gt" }
nnoremap { "<left>", "gT" }

-- Run the last command
nnoremap { "<leader><leader>c", "<cmd><up>" }

-- Make ESC leave terminal mode
tnoremap { "<esc>", "<c-\\><c-n>" }

wk.register {
  -- Move lines
  ["<M-j>"] = {
    function()
      vim.cmd [[m .+1<CR>==]]
    end,
    "Move line down",
  },
  ["<M-k>"] = {
    function()
      vim.cmd [[m .-2<CR>==]]
    end,
    "Move line up",
  },

  -- Silent save
  ["<c-s>"] = { "<cmd>silent update<cr>", "save" },

  -- Does anyone even use macros?
  q = {
    function()
      local bufs = list_loaded_buffers()
      if #bufs > 1 then
        require("bufdelete").bufdelete(0, true)
      else
        vim.cmd "q"
      end
    end,
    "close",
  },
  Q = { "<cmd>quitall<cr>", ":quitall" },
}

wk.register({
  -- Move lines
  ["<M-j>"] = {
    function()
      vim.cmd [[m '>+1<CR>gv=gv]]
    end,
    "Move line down",
  },
  ["<M-k>"] = {
    function()
      vim.cmd [[m '<-2<CR>gv=gv]]
    end,
    "Move line up",
  },
}, {
  mode = "v",
})
