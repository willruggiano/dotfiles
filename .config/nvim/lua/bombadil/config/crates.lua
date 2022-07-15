local opts = {}

local has_coq, coq = pcall(require, "coq")
if has_coq then
  opts = vim.tbl_deep_extend("force", opts, {
    src = {
      coq = {
        enabled = true,
        name = "crates",
      },
    },
  })
end

require("crates").setup(opts)
