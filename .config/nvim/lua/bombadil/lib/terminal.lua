local ok, terminal = pcall(require, "toggleterm.terminal")
if not ok then
  return
end

local close_term_if_open = function()
  local ui = require "toggleterm.ui"
  local terminals = terminal.get_all()
  if not ui.find_open_windows() then
    return -- No open terminal
  end
  local target
  for i = #terminals, 1, -1 do
    local term = terminals[i]
    if term and ui.term_has_open_win(term) then
      target = term
      break
    end
  end
  if not target then
    return -- No open terminal
  end
  target:close()
end

return {
  close = close_term_if_open,
}
