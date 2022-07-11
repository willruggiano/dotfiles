vim.cmd [[command! BOnly lua require("close_buffers").delete({ type = "hidden" })]]
vim.cmd [[command! -nargs=* Plug :!plug <args>]]
vim.cmd [[command! -nargs=* K :lua require("bombadil.lib.terminal").run_command(true, "K", <q-args>)]]
