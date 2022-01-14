return function(direction)
  local count = vim.v.count
  local large = vim.g.large_jump_count or 5
  if count == 0 then
    vim.cmd("normal! g" .. direction)
  elseif count > large then
    vim.cmd [[normal! m']]
  end

  vim.cmd("normal! " .. count .. direction)
end
