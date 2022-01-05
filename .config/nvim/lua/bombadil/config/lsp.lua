local icons = require "nvim-nonicons"
local lsp = require "bombadil.lsp"
local lspconfig = require "lspconfig"
local lspconfig_util = require "lspconfig.util"
local nvim_status = require "lsp-status"
local wk = require "which-key"

local nnoremap = vim.keymap.nnoremap

lsp.kind.init()
lsp.status.activate()

vim.lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print "[LSP] Could not find definition"
    return
  end

  if vim.tbl_islist(result) then
    lsp.jump_to_location(result[1])
  else
    lsp.jump_to_location(result)
  end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity_limit = "Error",
    spacing = 4,
    prefix = icons.get "dot-fill",
  },
})

for type, icon in pairs(lsp.signs.get()) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

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
        name = "diagnostic",
        d = {
          function()
            vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(0)))
            vim.cmd "botright copen"
          end,
          "show-document",
        },
        l = {
          function()
            vim.diagnostic.open_float(0, { border = "single" })
          end,
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
        w = {
          function()
            vim.diagnostic.setqflist { open = false }
            vim.cmd "botright copen"
          end,
          "show-workspace",
        },
      },
      r = {
        name = "refactor",
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
      K = {
        lsp.peek_definition,
        "peek-definition",
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
  -- local custom_sources = require "bombadil.lsp.null-ls"
  null_ls.setup {
    debug = true,
    sources = {
      -- Formatting
      -- null_ls.builtins.formatting.clang_format, -- via clangd
      null_ls.builtins.formatting.cmake_format,
      -- null_ls.builtins.formatting.isort, -- via pylsp
      -- null_ls.builtins.formatting.nixfmt, -- via rnix-lsp
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.yapf, -- via pylsp
      -- Diagnostics
      null_ls.builtins.diagnostics.codespell,
      null_ls.builtins.diagnostics.luacheck.with { extra_args = { "--globals", "vim", "--no-max-line-length" } },
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.diagnostics.statix,
      -- custom_sources.statix.diagnostics,

      -- Code actions
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.code_actions.statix,
      -- custom_sources.statix.code_actions,
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
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
  capabilities = updated_capabilities,
}

lspconfig.pylsp.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
  settings = {
    ["pylsp.plugins.flake8.enable"] = true,
  },
}

-- NOTE: This is generated by Nix
local sumneko_cmd = require "bombadil.generated.sumneko"

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