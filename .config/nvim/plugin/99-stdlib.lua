os.capture = function(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

function string:contains(sub)
  return self:find(sub, 1, true) ~= nil
end

function string:startwith(start)
  return self:sub(1, #start) == start
end

function string:endswith(ending)
  return ending == "" or self:sub(-#ending) == ending
end

function string:replace(old, new)
  local s = self
  local search_start_idx = 1

  while true do
    local start_idx, end_idx = s:find(old, search_start_idx, true)
    if not start_idx then
      break
    end
    local postfix = s:sub(end_idx + 1)
    s = s:sub(1, start_idx - 1) .. new .. postfix
    search_start_idx = -1 * postfix:len()
  end

  return s
end

function string:insert(pos, text)
  return self:sub(1, pos - 1) .. text .. self:sub(pos)
end

utf8 = require "lua-utf8"
