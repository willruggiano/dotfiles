local function function_extension(ft, m)
  return function()
    vim.bo.filetype = ft
    if m then
      require("bombadil.filetype." .. m)
    else
      require("bombadil.filetype." .. ft)
    end
  end
end

require("filetype").setup {
  overrides = {
    extensions = {
      tpp = "cpp",
    },
    function_extensions = {
      bash = function_extension("bash", "shell"),
      cpp = function_extension "cpp",
      lua = function_extension "lua",
      md = function_extension "markdown",
      nix = function_extension "nix",
      sh = function_extension("sh", "shell"),
      snip = function_extension "snip",
      zsh = function_extension("zsh", "shell"),
    },
  },
}
