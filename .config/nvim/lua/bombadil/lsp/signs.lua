local icons = require "nvim-nonicons"
local f = require "bombadil.lib.functional"

local signs = {
  Error = icons.get "circle-slash",
  Hint = icons.get "light-bulb",
  Info = icons.get "info",
  Warn = icons.get "alert",
}

local M = {}

---@param lower boolean
M.get = function(lower)
  if lower then
    local s = {}
    for k, v in pairs(signs) do
      s[string.lower(k)] = v
    end
    return s
  else
    return signs
  end
end

---@param func funcref
M.map = function(func)
  f.each(f.partial(func, signs), ipairs(vim.tbl_keys(signs)))
end

return M
