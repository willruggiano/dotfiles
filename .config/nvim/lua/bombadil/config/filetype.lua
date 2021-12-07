require("filetype").setup {
  overrides = {
    extensions = {
      tpp = "cpp",
    },
    literal = {
      -- TODO: For some reason these don't take
      ["firvish://buffers"] = "firvish-buffers",
      ["firvish://history"] = "firvish-history",
      ["firvish://menu"] = "firvish-menu",
    },
  },
}
