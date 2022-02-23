local cmp = require "cmp"
local snippy = require "snippy"
local neogen = require "neogen"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

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
    ["<CR>"] = function(fallback)
      if cmp.visible() then
        return cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        }(fallback)
      else
        return fallback()
      end
    end,
    ["<Tab>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() then
          return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return fallback()
        end
      end,
    },
    ["<S-Tab>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() then
          return cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return fallback()
        end
      end,
    },
    ["<C-space>"] = cmp.mapping {
      i = cmp.mapping.complete(),
    },
    ["<C-n>"] = function(_)
      if snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif neogen.jumpable() then
        neogen.jump_next()
      else
        print "No marks to jump to"
      end
    end,
    ["<C-p>"] = function(_)
      if snippy.can_jump(-1) then
        snippy.previous()
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        print "No previous marks to jump to"
      end
    end,
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "snippy" },
    -- { name = "cmp_shell" },
    { name = "buffer", group_index = 2 },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require "cmp_fuzzy_path.compare",
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
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

cmp.setup.cmdline(":", {
  sources = {
    { name = "fuzzy_path", options = { fd_cmd = { "fd", "-d", "20", "-p", "-H" } } },
    { name = "cmdline", group_index = 2 },
    -- { name = "path" },
    { name = "buffer", group_index = 3 },
  },
})

cmp.setup.cmdline("/", {
  sources = {
    { name = "cmdline" },
    { name = "nvim_lsp_document_symbol" },
    { name = "buffer", group_index = 2 },
  },
})

cmp.setup.filetype("gitcommit", {
  sources = {
    { name = "cmp_git" },
    { name = "buffer", group_index = 2 },
  },
})

require("cmp_git").setup()
