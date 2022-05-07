vim.cmd [[command! -bang -nargs=* CMake :lua require("bombadil.lib").cmake("<bang>" == "!", { <f-args> })]]
