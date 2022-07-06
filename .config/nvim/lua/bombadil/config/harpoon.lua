local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<space><cr>", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon" })

nnoremap("<leader>ma", function()
  require("harpoon.mark").add_file()
end, { desc = "Mark file" })
