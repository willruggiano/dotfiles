local wk = require "which-key"

local ok, lsp = pcall(require, "lspconfig.util")

for _, mode in ipairs { "n", "x" } do
  local mappings = {
    ["<leader>"] = {
      d = {
        name = "debug",
        i = { "<Plug>VimspectorBalloonEval", "eval" },
      },
    },
    ["<localleader>"] = {
      ["<f11>"] = { "<Plug>VimspectorUpFrame", "++frame" },
      ["<f12>"] = { "<Plug>VimspectorDownFrame", "--frame" },
    },
  }
  wk.register(mappings, { mode = mode })
end

local dap_config_file = ".vimspector.json"
local find_dap_config = function()
  if ok then
    local fname = vim.fn.expand "%:p"
    local root = lsp.find_git_ancestor(fname) or lsp.path.dirname(fname)
    if root then
      return root .. "/" .. dap_config_file
    end
  end
  return vim.fn.cwd() .. "/" .. dap_config_file
end

wk.register {
  ["<leader>d"] = {
    e = {
      function()
        local config = find_dap_config()
        if vim.fn.exists(config) then
          vim.cmd(string.format("edit %s", config))
        end
      end,
      "edit-config",
    },
  },
}

SetDapTarget = function(target)
  vim.g.dap_target = target
end

vim.cmd "command! -nargs=1 SetDebugTarget lua SetDapTarget(<f-args>)"
