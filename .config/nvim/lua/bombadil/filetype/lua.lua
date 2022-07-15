return function(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    vim.bo.textwidth = 100

    require "luadev"
  end)

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local vnoremap = require("bombadil.lib.keymap").vnoremap

  nnoremap("<leader><leader>rl", "<Plug>(Luadev-RunLine)", { buffer = bufnr })
  nnoremap("<leader><leader>ro", "<Plug>(Luadev-Run)", { buffer = bufnr })
  nnoremap("<leader><leader>rw", "<Plug>(Luadev-RunWord)", { buffer = bufnr })
  vnoremap("<leader><leader>r", "<Plug>(Luadev-Run)", { buffer = bufnr })
end
