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
    if string.find(vim.fn.bufname(b), "Wilder") then
      -- Don't count wilder.nvim buffers
    elseif vim.api.nvim_buf_is_loaded(b) then
      table.insert(loaded, b)
    end
  end
  return loaded
end

return {
  -- TODO: Get rid of these names
  delete_buffer = delete_buffer,
  list_loaded_buffers = list_loaded_buffers,
  -- Usage: require("bombadil.lib").buffer.function()
  delete = delete_buffer,
  loaded = list_loaded_buffers,
}
