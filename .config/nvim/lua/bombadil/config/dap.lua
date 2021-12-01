SetDapTarget = function(target)
  vim.g.dap_target = target
end

vim.cmd [[
  function! ListDebugTargets(A,L,P)
    return vimspector#GetConfigurations()
  endfun
]]

vim.cmd "command! -complete=customlist,ListDebugTargets -nargs=1 SetDebugTarget lua SetDapTarget(<f-args>)"

local dap = require "dap"

dap.set_log_level "TRACE"

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input "Port: ")
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode",
  name = "lldb",
}

dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host, port = config.port }
end

local wk = require "which-key"

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

local lsp = require "lspconfig.util"

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
