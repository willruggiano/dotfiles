vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.textwidth = 100

require "luadev"

local kommentary = require "kommentary.config"

kommentary.configure_language("lua", {
  prefer_single_line_comments = true,
})

local nnoremap = require("bombadil.lib.keymap").nnoremap
local vnoremap = require("bombadil.lib.keymap").vnoremap

nnoremap("<leader><leader>rl", "<Plug>(Luadev-RunLine)", { buffer = 0 })
nnoremap("<leader><leader>ro", "<Plug>(Luadev-Run)", { buffer = 0 })
nnoremap("<leader><leader>rw", "<Plug>(Luadev-RunWord)", { buffer = 0 })
vnoremap("<leader><leader>r", "<Plug>(Luadev-Run)", { buffer = 0 })
