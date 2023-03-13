local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, "No location found")
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

return function()
  local params = vim.lsp.util.make_position_params()
  local success, _ = pcall(
    vim.lsp.buf_request,
    vim.api.nvim_get_current_buf(),
    "textDocument/definition",
    params,
    preview_location_callback
  )
  if not success then
    print "error calling lsp textDocument/definition"
  end
end
