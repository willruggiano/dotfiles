local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<tab>", "<cmd>:bnext<cr>", { desc = ":bnext" })
nnoremap("<s-tab>", "<cmd>:bprev<cr>", { desc = ":bprev" })
