local job_ctrl = require "firvish.job_control"

local M = {}

M.generate = function(background, args)
  job_ctrl.start_job {
    cmd = vim.list_extend({ "cmake" }, args),
    filetype = "log",
    title = "cmake-generate",
    listed = true,
    output_qf = background,
    open_qf = background,
    is_background_job = background,
    cwd = vim.fn.getcwd(),
  }
end

M.build = function(background, args)
  job_ctrl.start_job {
    cmd = vim.list_extend({ "cmake" }, args),
    filetype = "log",
    title = "cmake-build",
    listed = true,
    output_qf = background,
    open_qf = background,
    is_background_job = background,
    cwd = vim.fn.getcwd(),
  }
end

return M
