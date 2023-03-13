---@diagnostic disable: assign-type-mismatch

local icons = require "nvim-nonicons"
local opt = vim.opt

vim.cmd.syntax "manual"

opt.termguicolors = true

-- Ignore compiled files
-- TODO: It'd be nice if we could use .gitignore for this?
opt.wildignore = { "*.o", "*~", "*.pyc", "*pycache*" }

opt.wildmode = { "longest", "full" }
opt.wildoptions = "pum"

-- Cool floating window popup menu for completion on command line
opt.pumblend = 17

opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1 -- Height of the command bar
opt.incsearch = true -- Makes search act like search in modern browsers
opt.showmatch = true -- show matching brackets when text indicator is over them
opt.relativenumber = true -- Show line numbers
opt.number = true -- But show the actual number for the line we're on
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ... unless there is a capital letter in the query
opt.hidden = true -- I like having buffers stay around
opt.cursorline = true -- Highlight the current line
opt.equalalways = false -- I don't like my windows changing all the time
opt.splitright = true -- Prefer windows splitting to the right
opt.splitbelow = true -- Prefer windows splitting to the bottom
opt.updatetime = 1000 -- Make updates happen faster
opt.hlsearch = true
opt.scrolloff = 10 -- Make it so there are always ten lines below my cursor
opt.signcolumn = "yes"
opt.conceallevel = 2

-- Tabs
opt.autoindent = true
opt.cindent = true
opt.wrap = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

opt.modelines = 1

opt.belloff = "all" -- Just turn the dang bell off

opt.clipboard = "unnamedplus"

opt.inccommand = "split"
opt.swapfile = false -- Living on the edge
opt.shada = { "!", "'1000", "<50", "s10", "h" }

opt.mouse = "n"

-- stylua: ignore start
opt.formatoptions = opt.formatoptions
  - "a"
  - "t"
  + "c"
  + "q"
  - "o"
  + "r"
  + "n"
  + "j"
  - "2"

opt.shortmess = opt.shortmess
  + "a"
  + "F"
-- stylua: ignore end

opt.joinspaces = false -- Two spaces and grade school, we're done

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = " ",
  foldclose = icons.get "chevron-right",
  foldsep = " ",
}
opt.listchars = { space = "." }

-- By default timeoutlen is 1000ms
opt.timeoutlen = 500

-- Allow local .nvimrc files
opt.exrc = true
-- ... but disallow autocommands
opt.secure = true

-- use ripgrep instead of native vimgrep
opt.grepprg = "rg --vimgrep --smart-case --follow"

-- I like help,man,K to open in a vertical split
opt.keywordprg = ":vert help"

-- opt.foldcolumn = "1"
-- opt.foldoptions = "nodigits"
opt.foldenable = true
opt.foldlevel = 99
