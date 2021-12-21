if vim.fn.executable "notify-send" == 1 then
  vim.notify = function(msg, level, opts)
    os.execute('notify-send "[neovim]: ' .. msg .. '"')
  end
else
  vim.notify = require "notify"
end
