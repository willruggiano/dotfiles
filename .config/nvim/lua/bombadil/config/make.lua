require("make").setup {
  default = {
    exe = "cmake",
    source_dir = vim.fn.getcwd(),
    build_parallelism = 8,
    generator = "Ninja",
    open_quickfix_on_error = true,
  },
}
