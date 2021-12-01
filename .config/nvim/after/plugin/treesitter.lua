local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
  return
end

local swap_next, swap_prev = (function()
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    e = "@element",
    v = "@variable",
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format("<space-s>%s", key)] = obj
    p[string.format("<space-s>%s", string.upper(key))] = obj
  end

  return n, p
end)()

require("nvim-treesitter.configs").setup {
  autopairs = { enable = true },

  -- NOTE: Installed by Nix.
  -- ensure_installed = { "cpp", "lua", "nix", "python" },

  highlight = {
    enable = true,
    use_languagetree = false,
    disable = { "cmake", "json" },
  },

  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },

  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },

    smart_rename = {
      enable = false,
      keymaps = {
        -- mapping to rename reference under cursor
        smart_rename = "grr",
      },
    },

    -- TODO: This seems broken...
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
        list_definitions = "gnD", -- mapping to list all definitions in current file
      },
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<space-s>i", -- maps in normal mode to init the node/scope selection
      node_incremental = "<space-s>i", -- increment to the upper named parent
      node_decremental = "<space-s>d", -- decrement to the previous node
      scope_incremental = "<space-s>s", -- increment to the upper scope (as defined in locals.scm)
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

vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  ["<leader>t"] = {
    name = "treesitter",
    h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "captures" },
    p = { "<cmd>TSPlaygroundToggle<cr>", "playground" },
  },
}
