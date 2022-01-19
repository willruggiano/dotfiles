autocmd BufWritePre * lua vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
