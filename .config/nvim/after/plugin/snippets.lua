local luasnip = require "luasnip"

luasnip.config.set_config {
  history = true,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
}

require("luasnip.loaders.from_vscode").load()

--- <tab> to jump to next snippet's placeholder
local function on_tab()
  return luasnip.jump(1) and "" or vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
end

--- <s-tab> to jump to next snippet's placeholder
local function on_s_tab()
  return luasnip.jump(-1) and "" or vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
end

local inoremap = vim.keymap.inoremap
local snoremap = vim.keymap.snoremap

-- inoremap({ "<tab>", on_tab, expr = true })
-- snoremap({ "<tab>", on_tab, expr = true })
-- inoremap({ "<s-tab>", on_s_tab, expr = true })
-- snoremap({ "<s-tab>", on_s_tab, expr = true })
