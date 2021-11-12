local wk = require "which-key"
local inoremap = vim.keymap.inoremap
local nnoremap = vim.keymap.nnoremap
local tnoremap = vim.keymap.tnoremap

local lib = require "bombadil.lib"

local quit = function()
  vim.cmd "q"
  return true
end
local bufdelete = function()
  local bufs = lib.buffer.loaded()
  if #bufs > 1 then
    require("bufdelete").bufdelete(0, true)
    return true
  end
  -- bufdelete on the last buffer does nothing
  return false
end
local ft_closers = {
  ["firvish-job-list"] = quit,
  ["firvish-job-output"] = quit,
  harpoon = quit,
  help = quit,
  man = quit,
}
local bt_closers = {
  quickfix = function()
    vim.cmd "cclose"
  end,
  terminal = quit,
}
local close = function()
  if vim.fn.bufname "%" == "" then
    quit()
  end
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype
  local fn = ft_closers[ft] or bt_closers[bt] or bufdelete
  if fn() then
    -- Success; nothing to do.
  else
    -- The defacto fallback.
    quit()
  end
end

-- WhichKey doesn't seem to like these
-- Opens line above or below the current line
-- TODO: These don't seem to take for some reason...
-- inoremap { "<c-cr>", "<c-o>O" }
-- inoremap { "<s-cr>", "<c-o>o" }
inoremap { "<c-k>", "<c-o>O" }
inoremap { "<c-j>", "<c-o>o" }

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
  q = { close, "close" },
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
