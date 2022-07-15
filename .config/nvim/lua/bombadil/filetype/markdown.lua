return function(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.wo.conceallevel = 3
    -- FIXME: The markdown queries are broken.
    require("treesitter-unit").disable_highlighting()
  end)

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local zk = require "zk"

  nnoremap("<leader>zb", function()
    zk.edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { title = "Backlinks" })
  end, { buffer = bufnr, desc = "Backlinks" })

  nnoremap("<leader>zl", function()
    zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { title = "Links" })
  end, { buffer = bufnr, desc = "Links" })
end
