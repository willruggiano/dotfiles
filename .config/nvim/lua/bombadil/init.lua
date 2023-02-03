-- Enable this with `nvim --cmd 'lua vim.g.debug_options = true'`
if vim.g.debug_options then
  require "bombadil.meta.options"
end

require "bombadil.globals"
require "bombadil.stdlib"

require "bombadil.options"
require "bombadil.abbreviations"
require "bombadil.autocommands"
require "bombadil.commands"
require "bombadil.filetype"
require "bombadil.keymaps"
require "bombadil.override"

require("bombadil.localrc").load()
