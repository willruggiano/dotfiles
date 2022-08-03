if pcall(require, "coq") then
  error "[setup] both nvim-cmp and coq.nvim are installed"
  return
end

local cmp = require "cmp"
local snippy = require "snippy"
local neogen = require "neogen"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("cmp_git").setup()
require("cmp_shell").setup()

cmp.setup {
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-5),
    ["<C-u>"] = cmp.mapping.scroll_docs(5),
    ["<C-c>"] = cmp.mapping.close(),
    ["<C-y>"] = function(fallback)
      if cmp.visible() then
        return cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }(fallback)
      else
        return fallback()
      end
    end,
    ["<C-space>"] = cmp.mapping {
      ---@diagnostic disable-next-line: missing-parameter
      i = cmp.mapping.complete(),
    },
    ["<C-n>"] = cmp.mapping {
      i = function(fallback)
        if snippy.can_expand_or_advance() then
          snippy.expand_or_advance()
        elseif neogen.jumpable() then
          neogen.jump_next()
        elseif cmp.visible() then
          return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return fallback()
        end
      end,
    },
    ["<C-p>"] = cmp.mapping {
      i = function(fallback)
        if snippy.can_jump(-1) then
          snippy.previous()
        elseif neogen.jumpable(-1) then
          neogen.jump_prev()
        elseif cmp.visible() then
          return cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return fallback()
        end
      end,
    },
  },
  sources = cmp.config.sources({
    { name = "shell" },
  }, {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "snippy" },
  }, {
    { name = "buffer" },
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      function(...)
        return require("cmp_buffer"):compare_locality(...)
      end,
      require "cmp_fuzzy_path.compare",
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      require "clangd_extensions.cmp_scores",
      require("cmp-under-comparator").under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  formatting = {
    format = require("lspkind").cmp_format {
      mode = "symbol",
      maxwidth = 50,
    },
  },
}

cmp.setup.filetype("gitcommit", {
  sources = {
    { name = "cmp_git" },
    { name = "buffer", group_index = 2 },
  },
})
