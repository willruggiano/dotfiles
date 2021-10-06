local inoremap = vim.keymap.inoremap

vim.opt.completeopt = { "menuone", "noselect" }

-- Don't show the dumb matching stuff
vim.opt.shortmess:append "c"
vim.opt.pumheight = 20

local use_cmp = false
local use_coq = true

local setup_cmp = function()
  local cmp = require "cmp"
  cmp.setup {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },

    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.close(),
      ["<C-y>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },

      -- TODO: Not sure I'm in love with this one.
      ["<C-Space>"] = cmp.mapping.complete(),
    },

    sources = {
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
  }

  require("nvim-autopairs.completion.cmp").setup {
    map_cr = true,
    map_complete = true,
    auto_select = false,
  }
end

local setup_coq = function()
  require "coq_3p" {
    {
      src = "nvimlua",
      short_name = "nLUA",
    },
    {
      src = "repl",
      sh = "zsh",
      -- shell = { p = "perl", n = "node", ... },
      max_lines = 99,
      deadline = 500,
    },
  }

  inoremap { "<c-h>", "<c-\\><c-n><cmd>lua COQ.Nav_mark()<cr>" }
end

if use_cmp then
  setup_cmp()
elseif use_coq then
  setup_coq()
end
