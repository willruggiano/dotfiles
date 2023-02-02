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

local colors = require "bombadil.colors"

require("lualine").setup {
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "gruvbox",
    -- theme = {
    --   normal = {
    --     a = { bg = colors.gray, fg = colors.black, gui = "bold" },
    --     b = { bg = colors.lightgray, fg = colors.white },
    --     c = { bg = colors.darkgray, fg = colors.gray },
    --   },
    --   insert = {
    --     a = { bg = colors.blue, fg = colors.black, gui = "bold" },
    --     b = { bg = colors.lightgray, fg = colors.white },
    --     c = { bg = colors.lightgray, fg = colors.white },
    --   },
    --   visual = {
    --     a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
    --     b = { bg = colors.lightgray, fg = colors.white },
    --     c = { bg = colors.inactivegray, fg = colors.black },
    --   },
    --   replace = {
    --     a = { bg = colors.red, fg = colors.black, gui = "bold" },
    --     b = { bg = colors.lightgray, fg = colors.white },
    --     c = { bg = colors.black, fg = colors.white },
    --   },
    --   command = {
    --     a = { bg = colors.green, fg = colors.black, gui = "bold" },
    --     b = { bg = colors.lightgray, fg = colors.white },
    --     c = { bg = colors.inactivegray, fg = colors.black },
    --   },
    --   inactive = {
    --     a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
    --     b = { bg = colors.darkgray, fg = colors.gray },
    --     c = { bg = colors.darkgray, fg = colors.gray },
    --   },
    -- },
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
