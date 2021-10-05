vim.cmd [[command! PackerInstall packadd packer.nvim | lua R('bombadil.plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua R('bombadil.plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua R('bombadil.plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua R('bombadil.plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua R('bombadil.plugins').compile()]]
vim.cmd [[command! PackerStatus packadd packer.nvim | lua R('bombadil.plugins').status()]]

vim.cmd [[command! BOnly lua require("close_buffers").delete({ type = "hidden" })]]
