local job_ctrl = require "firvish.job_control2"

local M = {}

---Run an executable.
---@param command string The command to run.
---@param errorlist string|boolean One of (quickfix|loclist|false) specifying whether to send command output to an errorlist, or `false` to run the command in the foregroud.
---@param args table The arguments to pass to the command.
M.run = function(command, args, errorlist)
  local background = errorlist ~= false

  job_ctrl.start_job {
    cmd = vim.list_extend({ command }, args),
    filetype = "log",
    title = command,
    errorlist = errorlist,
    eopen = background,
    bopen = false,
  }
end

return M
