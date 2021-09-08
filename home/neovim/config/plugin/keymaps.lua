local nnoremap = vim.keymap.nnoremap
local inoremap = vim.keymap.inoremap
local tnoremap = vim.keymap.tnoremap

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

-- Opens line below or above current line
inoremap { "<s-cr>", "<c-o>o" }
inoremap { "<c-cr>", "<c-o>O" }

-- Run the last command
nnoremap { "<leader><leader>c", "<cmd><up>" }

-- Make ESC leave terminal mode
tnoremap { "<esc>", "<c-\\><c-n>" }

-- Toggle hlsearch
nnoremap {
  "<m-cr>",
  function()
    vim.v.hlsearch = not vim.v.hlsearch
  end,
}

-- Silence!
nnoremap { "<c-s>", "<cmd>silent update<cr>" }

-- Does anyone even use macros?
nnoremap { "q", "<c-w>q" }
