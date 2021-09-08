local keymap = require "astronauta.keymap"

-- Better buffer naviation.
keymap.map { "<tab>", "<cmd>BufMRUNext<cr>" }
keymap.map { "<s-tab>", "<cmd>BufMRUPrev<cr>" }
