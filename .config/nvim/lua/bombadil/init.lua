-- Enable this with `nvim --cmd 'lua vim.g.debug_options = true'`
if vim.g.debug_options then
  require "bombadil.meta.options"
end

-- Setup globals that I expect to always be available
require "bombadil.globals"

-- Source local configuration via .nvimrc.lua
require("bombadil.localrc").load()
