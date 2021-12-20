local shellexec = require "bombadil.lib.shellexec"

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register({
  ["E"] = {
    name = "execute",
    ["."] = { shellexec.line, "line" },
    f = { shellexec.file, "file" },
  },
}, { buffer = 0 })
