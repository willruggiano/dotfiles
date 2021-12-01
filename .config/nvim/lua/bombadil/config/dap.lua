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
