local inoremap = vim.keymap.inoremap

vim.opt.completeopt = { "menuone", "noselect" }

-- Don't show the dumb matching stuff
vim.opt.shortmess:append "c"
vim.opt.pumheight = 20

require "coq_3p" {
  {
    src = "nvimlua",
    short_name = "nLUA",
    conf_only = false,
  },
  {
    src = "repl",
    sh = "zsh",
    -- shell = { p = "perl", n = "node", ... },
    max_lines = 99,
    deadline = 500,
  },
}

-- Explicitly disabled in vim.g.coq_settings and mapped here instead to avoid the normal mode
-- mapping of the same key which conflicts with a custom mapping in keymaps.lua
inoremap { "<c-h>", "<c-\\><c-n><cmd>lua COQ.Nav_mark()<cr>" }
