local M = {}

function M.gsubenv(str)
  return string.gsub(str, "%$([%w_]+)", os.getenv)
end

return M
