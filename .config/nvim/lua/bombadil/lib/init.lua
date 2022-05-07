local function pinspect(object)
  print(vim.inspect(object))
  return object
end

local reload = require("plenary.reload").reload_module

local function rreload(modname)
  reload(modname)
  return require(modname)
end

return {
  -- modules
  buffer = require "bombadil.lib.buffers",
  cmake = require "bombadil.lib.cmake",
  functional = require "bombadil.lib.functional",
  jump = require "bombadil.lib.jump",
  term = require "bombadil.lib.terminal",
  -- "global" functions
  pinspect = pinspect,
  reload = reload,
  rreload = rreload,
}
