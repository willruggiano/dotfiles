vim.opt.completeopt = { "menuone", "noselect" }

-- Don't show the dumb matching stuff
vim.opt.shortmess:append "c"
vim.opt.pumheight = 20

require("compe").setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    nvim_lsp = true,
    nvim_lua = true,
    luasnip = true,
    spell = true,
    --[[ tabnine = {
      priority = 9999,
      sort = false,
      show_prediction_strength = true,
      ignore_pattern = "",
    }, ]]
  },
}

require("nvim-autopairs.completion.compe").setup {
  map_cr = false,
  map_complete = true,
}

local inoremap = vim.keymap.inoremap
local snoremap = vim.keymap.snoremap
local npairs = require "nvim-autopairs"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

inoremap { "<c-space>", "compe#complete()", expr = true }
inoremap { "<c-e>", 'compe#close("<c-e>")', expr = true }

_G.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc "<CR>")
    else
      return npairs.esc "<CR>"
    end
  else
    return npairs.autopairs_cr()
  end
end
inoremap { "<cr>", "v:lua.completion_confirm()", expr = true }

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif require("luasnip").expand_or_jumpable() then
    return t "<cmd>lua require'luasnip'.jump(1)<Cr>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require("luasnip").jumpable(-1) then
    return t "<cmd>lua require'luasnip'.jump(-1)<CR>"
  else
    return t "<S-Tab>"
  end
end

inoremap { "<tab>", "v:lua.tab_complete()", expr = true }
snoremap { "<tab>", "v:lua.tab_complete()", expr = true }
inoremap { "<s-tab>", "v:lua.s_tab_complete()", expr = true }
snoremap { "<s-tab>", "v:lua.s_tab_complete()", expr = true }
