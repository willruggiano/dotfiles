return function(bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "CargoExpand", function(args)
    require("cargo-expand").expand {
      args = vim.list_extend({ "expand" }, args.fargs or {}),
    }
  end, { nargs = "*" })
end
