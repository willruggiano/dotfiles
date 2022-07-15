return function(bufnr)
  require("bombadil.lib.keymap").nnoremap("<CR>", "<C-]>", { buffer = bufnr })
end
