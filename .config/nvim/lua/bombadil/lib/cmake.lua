local job_ctrl = require "firvish.job_control"

return function(background, args)
  job_ctrl.start_job {
    cmd = vim.list_extend({ "cmake" }, args),
    filetype = "log",
    title = "cmake",
    listed = true,
    output_qf = background,
    open_qf = background,
    is_background_job = background,
    cwd = vim.fn.getcwd(),
  }
end
