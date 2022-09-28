vim.filetype.add {
  extension = {
    bash = function()
      return "bash", require "bombadil.filetype.shell"
    end,
    cmake = function()
      return "cmake", require "bombadil.filetype.cmake"
    end,
    json = function()
      return "json", require "bombadil.filetype.json"
    end,
    lua = function()
      return "lua", require "bombadil.filetype.lua"
    end,
    man = function()
      return "man", require "bombadil.filetype.man"
    end,
    md = function()
      return "markdown", require "bombadil.filetype.markdown"
    end,
    nix = function()
      return "nix", require "bombadil.filetype.nix"
    end,
    sh = function()
      return "sh", require "bombadil.filetype.shell"
    end,
    snippet = function()
      return "snip", require "bombadil.filetype.snippet"
    end,
    tpp = "cpp",
    xit = "xit",
    zsh = function()
      return "zsh", require "bombadil.filetype.shell"
    end,
  },
  filename = {
    [".clang-format"] = "yaml",
    ["Cargo.toml"] = function()
      return "toml", require "bombadil.filetype.cargo"
    end,
    ["git-rebase-todo"] = function()
      return "gitrebase", require "bombadil.filetype.gitrebase"
    end,
  },
}
