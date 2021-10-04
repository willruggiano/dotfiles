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

-- Disable netrw
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

-- Disable filetype plugin
vim.g.did_load_filetypes = 1
