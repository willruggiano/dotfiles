local undotree = require "undotree"

undotree.setup()

require("bombadil.lib.keymap").nnoremap("<leader><leader>u", undotree.toggle, { desc = "Toggle undotree" })
