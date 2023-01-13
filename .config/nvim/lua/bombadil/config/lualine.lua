local extensions = {}

local lir = require "lir.vim"

extensions.firvish = {
  filetypes = {
    "firvish-buffers",
    "firvish-jobs",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_c = {
      {
        "filename",
        path = 2,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_c = {
      {
        "filename",
        path = 2,
      },
    },
    lualine_x = { "location" },
  },
}

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
    globalstatus = true,
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
    extensions.firvish,
    extensions.lir,
  },
}
