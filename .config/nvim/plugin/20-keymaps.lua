local wk = require "which-key"
local buffers = require "bombadil.lib.buffers"
local jump = require "bombadil.lib.jump"
local keymap = require "bombadil.lib.keymap"

local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap

local quit = function()
  vim.cmd "q"
  return true
end
local bufdelete = function()
  local bufs = buffers.loaded()
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
  tsplayground = quit,
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

-- Add large jumps to the jump list
for _, d in ipairs { "j", "k" } do
  nnoremap(d, function()
    jump(d)
  end)
end

-- WhichKey doesn't seem to like these
-- Opens line above or below the current line
inoremap("<c-k>", "<c-o>O")
inoremap("<c-j>", "<c-o>o")

-- Better pane navigation
nnoremap("<c-j>", "<c-w><c-j>")
nnoremap("<c-k>", "<c-w><c-k>")
nnoremap("<c-h>", "<c-w><c-h>")
nnoremap("<c-l>", "<c-w><c-l>")

-- Better window resize
nnoremap("+", "<c-w>+")
nnoremap("_", "<c-w>-")

-- Scrolling
nnoremap("<up>", "<c-y>")
nnoremap("<down>", "<c-e>")

-- Tab navigation
nnoremap("<right>", "gt")
nnoremap("<left>", "gT")

-- Make ESC leave terminal mode
tnoremap("<esc>", "<c-\\><c-n>")
tnoremap("<esc><esc>", function()
  require("bombadil.lib.terminal").close()
end)

-- Remap some of the single char yanks so they use the _ register
nnoremap("cj", [["_cj]])
nnoremap("ck", [["_ck]])
nnoremap("ch", [["_ch]])
nnoremap("cl", [["_cl]])
nnoremap("x", [["_x]])

wk.register {
  -- Jumplist as quickfix list
  ["<space><cr>"] = {
    function()
      local jumplist = vim.fn.getjumplist()[1]
      local sorted_jumplist = {}
      for i = #jumplist, 1, -1 do
        if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
          table.insert(sorted_jumplist, jumplist[i])
        end
      end
      vim.fn.setqflist({}, "r", { id = "jl", title = "jumplist", items = jumplist })
      vim.cmd "botright copen"
    end,
    "jumplist",
  },

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
