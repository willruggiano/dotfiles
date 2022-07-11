local kommentary = require "kommentary.config"

kommentary.configure_language("zig", {
  prefer_single_line_comments = true,
  single_line_comment_string = "//",
})
