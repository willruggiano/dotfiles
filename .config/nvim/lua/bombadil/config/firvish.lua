require("firvish").setup {
  features = true,
  -- features = {
  --   buffers = true,
  --   fh = true,
  --   find = true,
  --   grep = true,
  --   history = true,
  --   jobs = true,
  -- },
}

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<space>b", function()
  vim.cmd.edit "firvish://buffers"
end, { desc = "Buffers" })

nnoremap("<space>h", function()
  vim.cmd.edit "firvish://history"
end, { desc = "History" })

nnoremap("<space>j", function()
  vim.cmd.pedit "firvish://jobs"
end, { desc = "Jobs" })
