vim.filetype.add {
  extension = {
    tpp = "cpp",
  },
  filename = {
    [".clang-format"] = "yaml",
    ["Cargo.toml"] = function()
      return "toml", require "bombadil.filetype.cargo"
    end,
  },
}
