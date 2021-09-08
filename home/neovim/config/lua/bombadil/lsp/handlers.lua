local icons = require "nvim-nonicons"

vim.lsp.handlers["textDocument/definition"] = function(_, _, result)
  if not result or vim.tbl_isempty(result) then
    print "[LSP] Could not find definition"
    return
  end

  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1])
  else
    vim.lsp.util.jump_to_location(result)
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  require("lsp_extensions.workspace.diagnostic").handler,
  {
    underline = true,
    update_in_insert = true,
    virtual_text = {
      severity_limit = "Error",
      spacing = 4,
      prefix = icons.get "dot-fill",
    },
    severity_sort = true,
  }
)

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
