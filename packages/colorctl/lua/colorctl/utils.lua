local M = {}

function M.gsubenv(str)
  return string.gsub(str, "%$([%w_]+)", os.getenv)
end

function M.tbl_merge(t0, t1)
  for k, v in pairs(t1) do
    t0[k] = v
  end

  return t0
end

function M.to_rrggbb(color)
  if color:sub(0, 1) == "#" then
    -- It's in hex.
    return color:sub(2)
  else
    -- Assume it's already correct
    return color
  end
end

return M
