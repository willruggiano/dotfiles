local lspconfig = require "lspconfig"
local lspconfig_util = require "lspconfig.util"
local nvim_status = require "lsp-status"
local wk = require "which-key"

local nnoremap = vim.keymap.nnoremap
local telescope_mapper = require "bombadil.telescope.mappings"

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

  -- Mappings.
  wk.register({
    d = {
      name = "diagnostics",
      l = {
        vim.lsp.diagnostic.show_line_diagnostics,
        "show-line",
      },
      n = {
        vim.lsp.diagnostic.goto_next,
        "goto-next",
      },
      p = {
        vim.lsp.diagnostic.goto_prev,
        "goto-prev",
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
      D = {
        vim.lsp.buf.declaration,
        "declaration",
      },
      T = {
        vim.lsp.buf.type_definition,
        "type-definition",
      },
    },
    r = {
      name = "refactor",
      n = {
        vim.lsp.buf.rename,
        "rename",
      },
    },
    K = { vim.lsp.buf.hover, "hover" },
    ["<C-K>"] = {
      function()
        R("bombadil.lsp.handlers").peek_definition()
      end,
      "peek-definition",
    },
  }, {
    buffer = bufnr,
  })

  nnoremap {
    "<space>rr",
    function()
      vim.lsp.stop_client(vim.lsp.get_active_clients())
      vim.cmd [[e]]
    end,
    buffer = 0,
  }

  local opts = require("telescope.themes").get_ivy {
    winblend = 5,
    layout_config = {
      width = 0.25,
    },
    ignore_filename = true,
  }

  telescope_mapper("gr", "lsp_references", opts, true)

  telescope_mapper("<space>wd", "lsp_document_symbols", opts, true)
  telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", opts, true)

  telescope_mapper("<space>ca", "lsp_code_actions", nil, true)
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

lspconfig.pyright.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}

local sumneko_cmd = require "bombadil.lsp.sumneko"

lspconfig.sumneko_lua.setup(require("lua-dev").setup {
  lspconfig = {
    cmd = { sumneko_cmd },
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

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd [[command! Format execute 'lua vim.lsp.buf.formatting()']]
