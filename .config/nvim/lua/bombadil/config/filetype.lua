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
  },
}
