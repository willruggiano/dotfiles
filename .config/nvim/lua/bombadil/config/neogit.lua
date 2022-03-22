local neogit = require "neogit"

neogit.setup {
  integrations = {
    diffview = true,
  },
}

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<leader>gc", function()
  neogit.open { "commit" }
end, { desc = "Commit" })

nnoremap("<leader>gs", neogit.open, { desc = "Status" })
