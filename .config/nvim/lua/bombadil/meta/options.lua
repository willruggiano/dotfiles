-- I'm trying to track down why the formatoption "o" is being added for certain filetypes.
-- See plugins/10-options.lua for where I explicitly remove it.
-- Neovim even says that it is NOT set right after launching. Though, as soon as I open a file
-- something, somewhere is adding it back. Which is... annoying!

local _bo = getmetatable(vim.bo)
local _wo = getmetatable(vim.wo)
local _opt = getmetatable(vim.opt)
local _opt_global = getmetatable(vim.opt_global)
local _opt_local = getmetatable(vim.opt_local)

setmetatable(
  vim.bo,
  vim.tbl_extend("force", _bo, {
    __newindex = function(_, k, v)
      if vim.g.debug_options then
        print(string.format("setting buffer-local option %s to %s", k, vim.inspect(v)))
      end
      _bo.__newindex(_, k, v)
    end,
  })
)
setmetatable(
  vim.wo,
  vim.tbl_extend("force", _wo, {
    __newindex = function(_, k, v)
      if vim.g.debug_options then
        print(string.format("setting window-local option %s to %s", k, vim.inspect(v)))
      end
      _wo.__newindex(_, k, v)
    end,
  })
)
setmetatable(
  vim.opt,
  vim.tbl_extend("force", _opt, {
    __newindex = function(_, k, v)
      if vim.g.debug_options then
        print(string.format("setting option %s to %s", k, vim.inspect(v)))
      end
      _opt.__newindex(_, k, v)
    end,
  })
)
setmetatable(
  vim.opt_global,
  vim.tbl_extend("force", _opt_global, {
    __newindex = function(_, k, v)
      if vim.g.debug_options then
        print(string.format("setting global option %s to %s", k, vim.inspect(v)))
      end
      _opt_global.__newindex(_, k, v)
    end,
  })
)
setmetatable(
  vim.opt_local,
  vim.tbl_extend("force", _opt_local, {
    __newindex = function(_, k, v)
      if vim.g.debug_options then
        print(string.format("setting local option %s to %s", k, vim.inspect(v)))
      end
      _opt_local.__newindex(_, k, v)
    end,
  })
)
