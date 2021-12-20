-- We have to manually do this since filetype.vim doesn't get sourced (because we use the
-- filetype.nvim plugin)
vim.cmd [[runtime ftdetect/firvish.lua]]
