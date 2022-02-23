local dap = require "dap"
local json = require "rapidjson"
local utils = require "dap.utils"

local launch_json = vim.fn.expand ".vscode/launch.json"

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
    name = "Attach",
    type = "cppdbg",
    request = "attach",
    pid = utils.pick_process,
    args = {},
  },
  {
    name = "Launch",
    type = "cppdbg",
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

dap.adapters.cppdbg = {
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
        s = {
          function()
            if vim.fn.filereadable(launch_json) then
              local config = json.load(launch_json)
              for _, c in ipairs(config.configurations) do
                if c.type == "cppdbg" then
                  table.insert(dap.configurations.cpp, c)
                end
              end
            end
            dap.continue()
          end,
          "start-debugger",
        },
      },
    },
  }
  wk.register(mappings, { mode = mode })
end

wk.register {
  ["<leader>d"] = {
    e = {
      function()
        if vim.fn.exists(launch_json) then
          vim.cmd(string.format("edit %s", launch_json))
        end
      end,
      "edit-config",
    },
  },
}
