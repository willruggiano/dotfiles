if vim.fn.executable "notify-send" == 1 then
  vim.notify = function(msg, level, opts)
    os.execute('notify-send "[neovim]: ' .. msg .. '"')
  end
elseif vim.fn.executable "osascript" == 1 then
  vim.notify = function(msg, level, opts)
    os.execute([[osascript -e 'display notification "]] .. msg .. [["']])
  end
else
  vim.notify = require "notify"
end
