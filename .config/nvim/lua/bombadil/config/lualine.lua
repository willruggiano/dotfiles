local extensions = {}

local lir = require "lir.vim"

extensions.lir = {
  filetypes = { "lir" },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      function()
        return lir.get_context().dir
      end,
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_c = {
      function()
        return lir.get_context().dir
      end,
    },
    lualine_x = { "location" },
  },
}

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {
    "quickfix",
    "toggleterm",
    extensions.lir,
  },
}

require("fidget").setup {
  text = {
    spinner = "dots",
  },
  sources = {
    ["null-ls"] = {
      ignore = true,
    },
  },
}
