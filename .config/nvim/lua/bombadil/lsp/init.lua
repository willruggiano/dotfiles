local lspconfig = require "lspconfig"
local lspconfig_util = require "lspconfig.util"
local nvim_status = require "lsp-status"
local wk = require "which-key"

local nnoremap = vim.keymap.nnoremap

_ = require("lspkind").init()

require("bombadil.lsp.status").activate()

local handlers = require "bombadil.lsp.handlers"

local on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  local cursor_opts = require("telescope.themes").get_cursor()

  -- Mappings.
  wk.register({
    ["<leader>"] = {
      ca = {
        function()
          require("telescope.builtin").lsp_code_actions(cursor_opts)
        end,
        "code-action",
      },
      f = { vim.lsp.buf.formatting, "format" },
      d = {
        l = {
          vim.diagnostic.open_float,
          "show-line",
        },
        n = {
          vim.diagnostic.goto_next,
          "goto-next",
        },
        p = {
          vim.diagnostic.goto_prev,
          "goto-prev",
        },
      },
      r = {
        n = {
          vim.lsp.buf.rename,
          "rename",
        },
        r = {
          function()
            vim.lsp.stop_client(vim.lsp.get_active_clients())
            vim.cmd "e"
          end,
          "restart-clients",
        },
      },
      w = {
        name = "symbols",
        d = {
          vim.lsp.buf.document_symbol,
          "document",
        },
        w = {
          function()
            vim.lsp.buf.workspace_symbol ""
          end,
          "workspace",
        },
      },
    },
    g = {
      name = "goto",
      d = {
        vim.lsp.buf.definition,
        "definition",
      },
      i = {
        vim.lsp.buf.implementation,
        "implementation",
      },
      r = {
        vim.lsp.buf.references,
        "references",
      },
      D = {
        vim.lsp.buf.declaration,
        "declaration",
      },
      T = {
        vim.lsp.buf.type_definition,
        "type-definition",
      },
    },
    K = { vim.lsp.buf.hover, "hover" },
    ["<C-K>"] = {
      handlers.peek_definition,
      "peek-definition",
    },
  }, {
    buffer = bufnr,
  })

  wk.register({
    ["<leader>"] = {
      ca = {
        function()
          require("telescope.builtin").lsp_range_code_actions(cursor_opts)
        end,
        "code-action",
      },
      f = { vim.lsp.buf.range_formatting, "format" },
    },
  }, {
    buffer = bufnr,
    mode = "v",
  })
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = {
  dynamicRegistration = false,
}
updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

local has_coq, coq = pcall(require, "coq")
if has_coq then
  updated_capabilities = coq.lsp_ensure_capabilities({ capabilities = updated_capabilities }).capabilities
end

local has_null_ls, null_ls = pcall(require, "null-ls")
if has_null_ls then
  local custom_sources = require "bombadil.lsp.null-ls"
  null_ls.config {
    debug = true,
    sources = {
      -- Formatting
      -- null_ls.builtins.formatting.clang_format,  -- via clangd
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.formatting.isort,
      -- null_ls.builtins.formatting.nixfmt,  -- via rnix-lsp
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.formatting.yapf,
      -- Diagnostics
      null_ls.builtins.diagnostics.codespell,
      null_ls.builtins.diagnostics.shellcheck,
      -- null_ls.builtins.diagnostics.statix,
      custom_sources.statix.diagnostics,

      -- Code actions
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
      -- null_ls.builtins.code_actions.statix,
      custom_sources.statix.code_actions,
      -- Hover
      null_ls.builtins.hover.dictionary,
      -- Completion
      -- null_ls.builtins.completion.spell,
    },
  }

  null_ls.register {
    null_ls.builtins.diagnostics.cppcheck.with { filetypes = { "cpp" }, extra_args = { "--language", "cpp" } },
    null_ls.builtins.diagnostics.cppcheck.with { filetypes = { "c" }, extra_args = { "--language", "c" } },
  }

  lspconfig["null-ls"].setup {
    on_attach = on_attach,
  }
end

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu",
    "--suggest-missing-includes",
  },
  on_init = on_init,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    nnoremap { "<leader>a", "<cmd>ClangdSwitchSourceHeader<cr>", buffer = 0 }
  end,
  init_options = {
    clangdFileStatus = true,
    completeUnimported = true,
    semanticHighlighting = true,
    usePlaceholders = true,
  },
  handlers = nvim_status.extensions.clangd.setup(),
  capabilities = updated_capabilities,
}

lspconfig.cmake.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}

lspconfig.pylsp.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}

-- NOTE: This is generated by Nix
local sumneko_cmd = require "bombadil.lsp.sumneko"

lspconfig.sumneko_lua.setup(require("lua-dev").setup {
  lspconfig = {
    cmd = sumneko_cmd,
    on_init = on_init,
    on_attach = on_attach,
    capabilities = updated_capabilities,
    root_dir = function(fname)
      return lspconfig_util.find_git_ancestor(fname) or lspconfig_util.path.dirname(fname)
    end,
    globals = {
      -- Colorbuddy
      "Color",
      "c",
      "Group",
      "g",
      "s",
      -- Custom (see bombadil.globals)
      "RELOAD",
    },
  },
})

lspconfig.rnix.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}
