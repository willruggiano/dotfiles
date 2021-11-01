local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
  return
end

npairs.setup {
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "vim" },
}

-- local endwise = require('nvim-autopairs.ts-rule').endwise
-- npairs.add_rules({
--     endwise('{', '};', 'cpp', 'field_declaration_list')
-- })
