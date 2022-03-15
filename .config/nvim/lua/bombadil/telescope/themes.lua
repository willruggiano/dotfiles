local themes = require "telescope.themes"

return {
  cursor = themes.get_cursor {},
  ivy = themes.get_ivy { winblend = 5 },
}
