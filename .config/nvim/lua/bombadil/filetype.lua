vim.filetype.add {
  extension = {
    snippet = "snip",
    xit = "xit",
    -- C++
    ixx = "cpp",
    mxx = "cpp",
    txx = "cpp",
  },
  filename = {
    [".clang-format"] = "yaml",
    ["Cargo.toml"] = function()
      return "toml", require "bombadil.filetype.cargo"
    end,
    ["flake.lock"] = "json",
    ["git-rebase-todo"] = "gitrebase",
  },
}
