if require "bombadil.first_load"() then
  return
end

-- Leader key -> ","
vim.g.mapleader = ","
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

-- Setup globals that I expect to always be available
require "bombadil.globals"

-- Force loading of astronauta first.
vim.cmd [[runtime plugin/astronauta.vim]]

-- Configure the builtin LSP
require "bombadil.lsp"

-- Source local configuration via .nvimrc.lua
require("bombadil.localrc").load()
