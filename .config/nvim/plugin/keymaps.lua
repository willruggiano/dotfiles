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
-- These are things we want to *always* close, as opposed to (maybe) bdelete'ing and cycling to the
-- next buffer.
local quitters = {
  ["[nvim-lua]"] = quit, -- nvim-luadev
  ["firvish-job-list"] = quit,
  ["firvish-job-output"] = quit,
  help = quit,
  man = quit,
  quickfix = quit,
  terminal = quit,
}
local close = function(bt, ft, bname)
  local fn = quitters[ft] or quitters[bt] or quitters[bname] or bufdelete
  if fn() then
    -- Success; nothing to do.
  else
    -- The defacto fallback.
    quit()
  end
end

-- WhichKey doesn't seem to like these
-- Opens line above or below the current line
inoremap { "<c-k>", "<c-o>O" }
inoremap { "<c-j>", "<c-o>o" }

-- Better pane navigation
nnoremap { "<c-j>", "<c-w><c-j>" }
nnoremap { "<c-k>", "<c-w><c-k>" }
nnoremap { "<c-h>", "<c-w><c-h>" }
nnoremap { "<c-l>", "<c-w><c-l>" }

-- Better window resize
nnoremap { "+", "<c-w>+" }
nnoremap { "_", "<c-w>-" }

-- Scrolling
nnoremap { "<up>", "<c-y>" }
nnoremap { "<down>", "<c-e>" }

-- Tab navigation
nnoremap { "<right>", "gt" }
nnoremap { "<left>", "gT" }

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
  ["<c-s>"] = { "<cmd>silent update!<cr>", "save" },

  -- Does anyone even use macros?
  q = {
    function()
      close(vim.bo.buftype, vim.bo.filetype, vim.fn.bufname "%")
    end,
    "close",
  },
  Q = { "<cmd>quitall<cr>", ":quitall" },
  ["<leader>q"] = {
    "<cmd>quit<cr>",
    "quit",
  },
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
