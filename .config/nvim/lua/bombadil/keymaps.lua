local buffers = require "bombadil.lib.buffers"
local jump = require "bombadil.lib.jump"
local keymap = require "bombadil.lib.keymap"

local noremap = keymap.noremap
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap

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

-- Better buffer navigation
nnoremap("<tab>", "<cmd>:bnext<cr>", { desc = ":bnext" })
nnoremap("<s-tab>", "<cmd>:bprev<cr>", { desc = ":bprev" })

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

-- GOAT remaps?
xnoremap("<leader>p", [["_dP]])
noremap({ "n", "v" }, "<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])
noremap({ "n", "v" }, "<leader>d", [["_d]])

-- Jumplist as quickfix list
nnoremap("<leader>j", function()
  local jumplist = vim.fn.getjumplist()[1]
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
      table.insert(sorted_jumplist, jumplist[i])
    end
  end
  vim.fn.setqflist({}, "r", { id = "jl", title = "jumplist", items = jumplist })
  vim.cmd "botright copen"
end, { desc = "Jumplist" })

-- Move lines
nnoremap("<M-j>", function()
  vim.cmd [[m .+1<CR>==]]
end, { desc = "Move line down" })

nnoremap("<M-k>", function()
  vim.cmd [[m .-2<CR>==]]
end, { desc = "Move line up" })

-- Silent save
nnoremap("<c-s>", "<cmd>silent update!<cr>", { desc = "save" })

-- Move lines
vnoremap("<M-j>", function()
  vim.cmd [[m '>+1<CR>gv=gv]]
end, { desc = "Move line down" })

vnoremap("<M-k>", function()
  vim.cmd [[m '<-2<CR>gv=gv]]
end, { desc = "Move line up" })
