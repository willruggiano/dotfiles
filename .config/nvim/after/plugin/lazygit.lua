local ok, toggleterm = pcall(require, "toggleterm.terminal")
if not ok then
  return
end

if vim.fn.executable "lazygit" ~= 1 then
  return
end

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local Terminal = toggleterm.Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  border = "single",
  hidden = true,
}

wk.register {
  ["<space>g"] = {
    function()
      lazygit:toggle()
    end,
    "lazygit",
  },
}
