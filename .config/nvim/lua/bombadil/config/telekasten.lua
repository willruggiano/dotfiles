local notes = vim.fn.expand "~/notes"
local templates = notes .. "/templates"

require("telekasten").setup {
  home = notes,
  dailies = notes .. "/daily",
  weeklies = notes .. "/weekly",
  templates = templates,
  image_subdir = notes .. "/static/images",

  extension = ".md",
  image_link_style = "markdown",

  follow_creates_nonexisting = true,
  dailies_create_nonexisting = true,
  weeklies_create_nonexisting = true,

  template_new_note = templates .. "/default.md",
  template_new_daily = templates .. "/daily.md",
  template_new_weekly = templates .. "/weekly.md",

  plug_into_calendar = false,
}
