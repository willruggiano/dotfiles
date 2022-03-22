local shellexec = require "bombadil.lib.shellexec"

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("E.", shellexec.line, { buffer = 0, desc = "Execute line" })
nnoremap("Ef", shellexec.file, { buffer = 0, desc = "Execute file" })
