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

local hi = require("bombadil.colors").highlight
local palette = require "bombadil.colors.flavours"

hi.IndentBlanklineChar = { fg = palette.base02, nocombine = true }
hi.IndentBlanklineContextChar = { fg = palette.base04, nocombine = true }
