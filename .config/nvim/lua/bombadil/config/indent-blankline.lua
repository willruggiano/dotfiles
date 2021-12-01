require("indent_blankline").setup {
  buftype_exclude = {
    "quickfix",
    "help",
    "nofile",
    "prompt",
    "terminal",
  },
  filetype_exclude = {
    "man",
    "packer",
    "NeogitStatus",
    "NeogitCommitView",
    "NeogitLogView",
    "TelescopePrompt",
    "vimcmake",
  },
}
