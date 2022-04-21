local diff = require "diff-therapy"

vim.api.nvim_create_user_command("Smerge", diff.start, { nargs = 0 })
