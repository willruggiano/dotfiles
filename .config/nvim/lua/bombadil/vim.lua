local setloclist = vim.diagnostic.setloclist

vim.diagnostic.setloclist = function(...)
  setloclist(...)
  require("bombadil.lib.keymap").nnoremap("q", function()
    vim.cmd "lclose"
  end, { buffer = 0, desc = "close" })
end
