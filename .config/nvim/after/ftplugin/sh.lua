local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register({
  ["<leader><leader>r"] = {
    name = "run",
    f = {
      function()
        local filename = vim.fn.expand "%"
        vim.cmd("!" .. filename)
      end,
      "file",
    },
    l = {
      function()
        local linenr = vim.fn.line "."
        local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
        vim.cmd("!" .. line)
      end,
      "line",
    },
  },
}, { buffer = 0 })
