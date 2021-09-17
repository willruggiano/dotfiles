local cmd = vim.cmd

cmd [[command! PackerInstall packadd packer.nvim | lua R('bombadil.plugins').install()]]
cmd [[command! PackerUpdate packadd packer.nvim | lua R('bombadil.plugins').update()]]
cmd [[command! PackerSync packadd packer.nvim | lua R('bombadil.plugins').sync()]]
cmd [[command! PackerClean packadd packer.nvim | lua R('bombadil.plugins').clean()]]
cmd [[command! PackerCompile packadd packer.nvim | lua R('bombadil.plugins').compile()]]
cmd [[command! PackerStatus packadd packer.nvim | lua R('bombadil.plugins').status()]]

cmd [[cnoreabbrev h vert h]]
