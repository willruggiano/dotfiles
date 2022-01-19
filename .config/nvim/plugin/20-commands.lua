vim.cmd [[command! BOnly lua require("close_buffers").delete({ type = "hidden" })]]
vim.cmd [[command! -nargs=* Plug :!plug <args>]]
