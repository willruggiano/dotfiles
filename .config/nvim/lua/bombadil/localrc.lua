local ffi = require "ffi"
local lfs = require "lfs"
ffi.cdef [[
 int getuid(void);
]]

local function file_owned_by_me(file)
  return ffi.C.getuid() == lfs.attributes(file).uid
end

local function file_exists(file)
  return lfs.attributes(file) ~= nil
end

local function load()
  local local_rc_name = ".nvimrc.lua"
  if file_exists(local_rc_name) then
    if file_owned_by_me(local_rc_name) then
      dofile(local_rc_name)
    else
      print(local_rc_name .. " exists but is not loaded. Security reason: a diffent owner.")
    end
  end
end

return {
  load = load,
}
