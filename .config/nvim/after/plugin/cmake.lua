vim.api.nvim_create_user_command("CMake", function(opts)
  require("bombadil.lib").cmake(opts.bang or false, opts.fargs or {})
end, { desc = "CMake", bang = true, nargs = "*" })
