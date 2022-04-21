local swap_next, swap_prev = (function()
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    e = "@element",
    v = "@variable",
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format("<leader><leader>s%s", key)] = obj
    p[string.format("<leader><leader>s%s", string.upper(key))] = obj
  end

  return n, p
end)()

require("nvim-treesitter.configs").setup {
  autopairs = { enable = true },

  -- NOTE: Parsers are installed by nix.
  ensure_installed = {},

  highlight = {
    enable = true,
    use_languagetree = false,
    disable = { "cmake", "json" },
    custom_captures = {
      -- C++ alias declarations; `using <name> = <type>;`
      ["alias.name"] = "Variable",
      ["alias.type"] = "Type",
      ["function.return"] = "Keyword",
      ["function.parameter_type"] = "Keyword",
    },
  },

  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },

  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = { enable = false },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      -- NOTE: Disable the init_selection mapping and only map the inc/dec/scope maps.
      -- We want to "init selection" through other means, e.g. unit/node selectors: vau, vaf, et al
      init_selection = "<nop>",
      node_incremental = "<c-u>", -- Increment to the upper named parent
      node_decremental = "<c-p>", -- Decrement to the previous node
      scope_incremental = "<c-s>", -- Increment to the upper scope (as defined in locals.scm)
    },
  },

  context_commentstring = {
    enable = true,
    config = {
      c = "// %s",
      cpp = "// %s",
      lua = "-- %s",
    },
  },

  endwise = {
    enable = true,
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,

      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },

    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",

        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },

    swap = {
      enable = true,
      swap_next = swap_next,
      swap_previous = swap_prev,
    },
  },

  playground = {
    enable = true,
    updatetime = 25,
    persist_queries = true,
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",

      -- This shows stuff like literal strings, commas, etc.
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
}

local unit = require "treesitter-unit"

-- Highlights the current treesitter "unit"
-- Can be toggled with ,thu
-- unit.enable_highlighting()

vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

local nnoremap = require("bombadil.lib.keymap").nnoremap
local noremap = require("bombadil.lib.keymap").noremap

nnoremap("<leader>tu", unit.toggle_highlighting, { desc = "Toggle unit highlighting" })
nnoremap("<leader>tp", "<cmd>TSPlaygroundToggle<cr>", { desc = "Toggle treesitter playground" })

noremap({ "o", "x" }, "iu", [[:lua require("treesitter-unit").select()<cr>]], { desc = "inner unit" })
noremap({ "o", "x" }, "au", [[:lua require("treesitter-unit").select(true)<cr>]], { desc = "outer unit" })
