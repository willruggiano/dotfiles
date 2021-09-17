local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

return function()
  if not pcall(require, "packer") then
    if fn.empty(fn.glob(install_path)) > 0 then
      print "Installing packer..."
      fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
      execute "packadd packer.nvim"
      print "done."
    end

    return true
  end

  -- It seems that this is necessary?
  require("packer.luarocks").setup_paths()

  return false
end
