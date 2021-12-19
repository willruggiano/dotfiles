vim.keymap.nnoremap {
  "dd",
  function()
    local line = vim.fn.line "."
    require("firvish.buffers").buf_delete(line, line, true)
  end,
  buffer = 0,
  silent = true,
}
