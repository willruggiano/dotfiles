---@diagnostic disable-next-line: unused-local
local functions_query = [[
((function_declaration) @cap)
((function_definition) @cap)
]]

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

  nnoremap("<leader><leader>rl", "<Plug>(Luadev-RunLine)", { buffer = bufnr, desc = "Exec line" })
  nnoremap("<leader><leader>ro", "<Plug>(Luadev-Run)", { buffer = bufnr, desc = "Exec file" })
  nnoremap("<leader><leader>rw", "<Plug>(Luadev-RunWord)", { buffer = bufnr, desc = "Exec word" })
  vnoremap("<leader><leader>r", "<Plug>(Luadev-Run)", { buffer = bufnr, desc = "Exec selection" })

  -- nnoremap("<space>m", function()
  --   require("neo-minimap").browse {
  --     query = functions_query,
  --     width = math.floor(vim.api.nvim_win_get_width(0) * 0.4),
  --   }
  -- end, { buffer = bufnr, desc = "Show minimap" })
end
