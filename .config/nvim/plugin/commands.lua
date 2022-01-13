vim.cmd [[
  fun! PackerComplete(A,L,P)
    return luaeval('require"packer".plugin_complete(_A)', a:A)
  endfun
]]
vim.cmd [[command! -nargs=* -complete=customlist,PackerComplete PackerInstall lua require("bombadil.plugins").install(<f-args>)]]
vim.cmd [[command! -nargs=* -complete=customlist,PackerComplete PackerUpdate lua require("bombadil.plugins").update(<f-args>)]]
vim.cmd [[command! -nargs=* -complete=customlist,PackerComplete PackerSync lua require("bombadil.plugins").sync(<f-args>)]]
vim.cmd [[command! PackerClean lua require("bombadil.plugins").clean()]]
vim.cmd [[command! -nargs=* PackerCompile lua require("bombadil.plugins").compile(<q-args>)]]
vim.cmd [[command! PackerStatus lua require("bombadil.plugins").status()]]
vim.cmd [[command! PackerProfile lua require("bombadil.plugins").profile_output()]]

vim.cmd [[command! BOnly lua require("close_buffers").delete({ type = "hidden" })]]
