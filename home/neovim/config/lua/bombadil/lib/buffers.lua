local bufdelete = require("bufdelete").bufdelete

local delete_buffer = function(bufnr)
  if vim.fn.bufwinnr(bufnr) ~= -1 then
    bufdelete(bufnr, true)
  else
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

local list_loaded_buffers = function()
  local bufs = vim.api.nvim_list_bufs()
  local loaded = {}
  for _, b in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(b) then
      table.insert(loaded, b)
    end
  end
  return loaded
end

return {
  delete_buffer = delete_buffer,
  list_loaded_buffers = list_loaded_buffers,
}
