local job_ctrl = require "firvish.job_control"

local M = {}

M.generate = function(background, opts)
  opts = opts or {}

  local options = {}
  for _, e in ipairs(opts) do
    for k, v in string.gmatch(e, "(%w+)=(%w+)") do
      options[k] = v
    end
  end

  if #options == 0 then
    options = opts
  end

  P(options)

  vim.validate {
    source_dir = { options.source_dir, "string" },
    binary_dir = { options.binary_dir, "string" },
    build_type = { options.build_type, "string" },
    additional_args = { options.additional_args, "table", true },
  }

  local cmd = {
    "cmake",
    "-S",
    options.source_dir,
    "-B",
    options.binary_dir,
    "-DCMAKE_BUILD_TYPE=" .. options.build_type,
    "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
  }

  local additional_args = options.additional_args or {}
  if #additional_args > 0 then
    for _, i in ipairs(additional_args) do
      cmd[#cmd + 1] = i
    end
  end

  job_ctrl.start_job {
    cmd = cmd,
    filetype = "log",
    title = "cmake-generate",
    listed = true,
    output_qf = true,
    is_background_job = background,
    cwd = vim.fn.getcwd(),
  }
end

M.build = function(background, opts)
  opts = opts or {}

  vim.validate {
    binary_dir = { opts.binary_dir, is_not_nil, "opts.binary_dir is required" },
    build_target = { opts.build_target, is_not_nil, "opts.build_target is required" },
    build_type = { opts.build_type, is_not_nil, "opts.build_type is required" },
    additional_args = { opts.additional_args, "table", true },
  }

  local cmd = {
    "cmake",
    "--build",
    opts.binary_dir,
    "--config",
    opts.build_type,
    "--target",
    opts.build_target,
    "--parallel",
  }

  local additional_args = opts.additional_args or {}
  if #additional_args > 0 then
    for _, i in ipairs(additional_args) do
      cmd[#cmd + 1] = i
    end
  end

  job_ctrl.start_job {
    cmd = cmd,
    filetype = "log",
    title = "cmake-build",
    listed = true,
    output_qf = true,
    is_background_job = background,
    cwd = vim.fn.getcwd(),
  }
end

return M
