local icons = require "nvim-nonicons"

local jump_to_location = function(location)
  local uri = location.uri or location.targetUri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)

  if vim.api.nvim_buf_is_loaded(bufnr) then
    local wins = vim.fn.win_findbuf(bufnr)
    if wins then
      vim.fn.win_gotoid(wins[1])
    end
  end

  if vim.lsp.util.jump_to_location(location) then
    vim.cmd "normal! zz"
    return true
  else
    return false
  end
end

vim.lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print "[LSP] Could not find definition"
    return
  end

  if vim.tbl_islist(result) then
    jump_to_location(result[1])
  else
    jump_to_location(result)
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity_limit = "Error",
    spacing = 4,
    prefix = icons.get "dot-fill",
  },
})

local signs = {
  Error = icons.get "circle-slash",
  Warning = icons.get "alert",
  Hint = icons.get "light-bulb",
  Information = icons.get "info",
}

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local compute_target_range_using_ts = function(location)
  local uri = location.targetUri or location.uri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local syntax = vim.api.nvim_buf_get_option(bufnr, "syntax")
  if syntax == "" then
    -- When no syntax is set, we use filetype as fallback. This might not result
    -- in a valid syntax definition. See also ft detection in stylize_markdown.
    -- An empty syntax is more common now with TreeSitter, since TS disables syntax.
    syntax = vim.api.nvim_buf_get_option(bufnr, "filetype")
  end
  local parser = vim.treesitter.get_parser(bufnr, syntax)
  local tree = parser:parse()[1]
  local range = location.targetRange or location.range
  range = { range.start.line, range.start.character, range["end"].line, range["end"].character }
  -- TODO: [2021-09-14,wruggian]: This will give us the signature of the definition, which is not
  -- what we need
  local target = tree:root():named_descendant_for_range(unpack(range))
  -- TODO: [2021-09-14,wruggian]: This doesn't quite work because it is language specific what is
  -- the true "target" node
  local parent = target:parent():parent():parent()
  local start_row, start_col, end_row, end_col = parent:range()
  if location.targetRange ~= nil then
    local target_range = location.targetRange
    target_range.start.line = start_row
    target_range.start.character = start_col
    target_range["end"].line = end_row
    target_range["end"].character = end_col
    location.targetRange = target_range
  else
    local target_range = location.range
    target_range.start.line = start_row
    target_range.start.character = start_col
    target_range["end"].line = end_row
    target_range["end"].character = end_col
    location.range = target_range
  end
  return location
end

local use_ts = true

local compute_target_range = function(location)
  if use_ts then
    return compute_target_range_using_ts(location)
  end
  local context = 15
  -- We need to change the range reported by the LSP (at least for clangd) since it only gives us
  -- the first line of the definition
  if location.targetRange ~= nil then
    local range = location.targetRange
    range["end"].line = range["end"].line + context
    location.targetRange = range
  else
    local range = location.range
    range["end"].line = range["end"].line + context
    location.range = range
  end
  return location
end

local preview_location = function(location, method)
  location = compute_target_range(location)
  return vim.lsp.util.preview_location(location, { border = "single" })
end

local M = {}

M.peek_definition = function()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, ctx)
    if vim.tbl_islist(result) then
      preview_location(result[1], ctx.method)
    else
      preview_location(result, ctx.method)
    end
  end)
end

return M
