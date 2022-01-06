if require "bombadil.first_load"() then
  return
end

-- Setup globals that I expect to always be available
require "bombadil.globals"

-- Source local configuration via .nvimrc.lua
require("bombadil.localrc").load()
