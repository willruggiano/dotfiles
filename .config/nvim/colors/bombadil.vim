set termguicolors
set background=dark
let g:colors_name="bombadil"

lua package.loaded["bombadil.colorscheme"] = nil

lua require("lush")(require "bombadil.colorscheme")
