local ok, wk = pcall(require, "which-key")
if not ok then
  return
end
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

wk.register {
  ["<space><space>"] = {
    function()
      toggleterm.toggle_command("direction=float", 0)
    end,
    "terminal",
  },
}
