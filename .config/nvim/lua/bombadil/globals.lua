local lib = require "bombadil.lib"

-- TODO: Eliminate usage of these globals in favor of lib usage
P = lib.pinspect
RELOAD = lib.reload
R = lib.rreload

vim.g.mapleader = ","

-- Disable builtins
vim.g.loaded_2html_plugin = true
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_gzip = true
vim.g.loaded_logiPat = true
vim.g.loaded_matchit = true
vim.g.loaded_matchparen = true
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true
vim.g.loaded_rrhelper = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true

vim.g.no_gitrebase_maps = true

-- Use Lua filetype detection
vim.g.do_filetype_lua = true
