local dap = require "dap"
local json = require "rapidjson"
local utils = require "dap.utils"

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

local noremap = require("bombadil.lib.keymap").noremap
local nnoremap = require("bombadil.lib.keymap").nnoremap

local loaded_launch_json = {}
local launch_json = ".vscode/launch.json"

local mappings = {
  ["<leader>ds"] = {
    function()
      if vim.fn.filereadable(launch_json) == 1 and loaded_launch_json[launch_json] == nil then
        local config = json.load(launch_json)
        for _, c in ipairs(config.configurations) do
          if c.type == "cppdbg" then
            table.insert(dap.configurations.cpp, c)
          end
        end
        loaded_launch_json[launch_json] = true
      end
      dap.continue()
    end,
    { desc = "Start debugger" },
  },
}

for key, opts in pairs(mappings) do
  noremap({ "n", "x" }, key, opts[1], opts[2])
end

nnoremap("<leader>de", function()
  if vim.fn.exists(launch_json) then
    vim.cmd(string.format("edit %s", launch_json))
  end
end, { desc = "Edit debugger config" })
