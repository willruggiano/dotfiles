P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- Leader key -> ","
vim.g.mapleader = ","

-- Disable builtins
vim.g.loaded_gzip = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true

vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true
vim.g.loaded_2html_plugin = true

vim.g.loaded_matchit = true
vim.g.loaded_matchparen = true
vim.g.loaded_logiPat = true
vim.g.loaded_rrhelper = true

vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true

vim.g.no_gitrebase_maps = true

vim.g.did_load_filetypes = true
