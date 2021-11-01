local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local ok, lsp = pcall(require, "lspconfig.util")
if not ok then
  return
end

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

vim.cmd [[
  function! ListDebugTargets(A,L,P)
    return vimspector#GetConfigurations()
  endfun
]]

vim.cmd "command! -complete=customlist,ListDebugTargets -nargs=1 SetDebugTarget lua SetDapTarget(<f-args>)"

local dap, dapui = require "dap", require "dapui"

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

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
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

vim.g.dap_virtual_text = true

require("dapui").setup {
  sidebar = {
    elements = {
      { id = "scopes", size = 0.25 },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 50,
    position = "left",
  },
  tray = {
    elements = { "repl" },
    size = 15,
    position = "bottom",
  },
  floating = {
    max_height = nil,
    max_width = nil,
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
}

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
