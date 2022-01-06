vim.cmd [[command! -bang -nargs=* CMakeGenerate :lua require("bombadil.lib.cmake").generate("<bang>" == "!", { <f-args> })]]
vim.cmd [[command! -bang -nargs=* CMakeBuild :lua require("bombadil.lib.cmake").build("<bang>" == "!", { <f-args> })]]
