local diff = require "diff-therapy"

vim.api.nvim_add_user_command("Smerge", diff.start, { nargs = 0 })
