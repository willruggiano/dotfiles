local neogen = require "neogen"

neogen.setup {}

require("bombadil.lib.keymap").nnoremap("<leader>da", neogen.generate, { desc = "Add docstring" })
