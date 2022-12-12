local neogen = require "neogen"

neogen.setup {}

require("bombadil.lib.keymap").nnoremap("<leader><leader>a", neogen.generate, { desc = "Add docstring" })
