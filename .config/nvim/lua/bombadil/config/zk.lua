local zk = require "zk"

zk.setup {}

require("zk.commands").add("ZkNewDoc", function(options)
  zk.new(vim.tbl_extend("force", { dir = "docs" }, options))
end)

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<space>z", function()
  zk.edit({}, { title = "Notes" })
end)

nnoremap("<leader>zi", zk.index)

nnoremap("<leader>zn", function()
  zk.new { title = vim.fn.input "Title: " }
end)

nnoremap("<leader>zf", function()
  local query = vim.fn.input "Query: "
  zk.edit({ sort = { "modified" }, match = query }, { title = string.format([[Notes matching "%s"]], query) })
end)
