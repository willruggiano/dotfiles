local lsp = require "bombadil.lsp"
local lspconfig = require "lspconfig"
local lspconfig_util = require "lspconfig.util"
local telescope_themes = require "bombadil.telescope.themes"

local lsp_cmds = require "bombadil.generated.lsp"

lsp.kind.init()

local has_lsp_lines, lsp_lines = pcall(require, "lsp_lines")
if has_lsp_lines then
  lsp_lines.register_lsp_virtual_lines()
end

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

local diagnostic_config = {
  severity_sort = true,
  signs = false,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s  %s", lsp.signs.severity(diagnostic.severity), diagnostic.message)
    end,
    prefix = "",
    spacing = 4,
  },
}

if has_lsp_lines then
  diagnostic_config = vim.tbl_extend("force", diagnostic_config, {
    virtual_lines = true,
    virtual_text = false,
  })
end

vim.diagnostic.config(diagnostic_config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

---@diagnostic disable-next-line: missing-parameter
for type, icon in pairs(lsp.signs.get()) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local nnoremap = require("bombadil.lib.keymap").nnoremap
local vnoremap = require("bombadil.lib.keymap").vnoremap

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  local mappings = {
    ["]d"] = {
      vim.diagnostic.goto_next,
      { buffer = bufnr, desc = "Next diagnostic" },
    },
    ["[d"] = {
      vim.diagnostic.goto_prev,
      { buffer = bufnr, desc = "Previous diagnostic" },
    },
    ["<leader>ca"] = {
      function()
        require("telescope.builtin").lsp_code_actions(telescope_themes.cursor)
      end,
      { buffer = bufnr, desc = "Code actions" },
    },
    ["<leader>f"] = {
      function()
        local disabled_clients = {
          cmake = true,
          rnix = true,
          sumneko_lua = true,
        }
        vim.lsp.buf.format {
          async = true,
          filter = function(client)
            if disabled_clients[client.name] then
              return false
            end
            return true
          end,
        }
      end,
      { buffer = bufnr, desc = "Format" },
    },
    ["<leader>dd"] = {
      function()
        vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(0)))
        vim.cmd "botright copen"
      end,
      { buffer = bufnr, desc = "Document diagnostics" },
    },
    ["<leader>dl"] = {
      function()
        vim.diagnostic.open_float(0, { border = "single" })
      end,
      { buffer = bufnr, desc = "Line diagnostics" },
    },
    ["<leader>dw"] = {
      function()
        vim.diagnostic.setqflist { open = false }
        vim.cmd "botright copen"
      end,
      { buffer = bufnr, desc = "Workspace diagnostics" },
    },
    ["<leader>rn"] = {
      vim.lsp.buf.rename,
      { buffer = bufnr, desc = "Rename" },
    },
    ["<leader>rr"] = {
      function()
        vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
        vim.cmd "e"
      end,
      { buffer = bufnr, desc = "Restart lsp clients" },
    },
    ["<leader>th"] = {
      require("clangd_extensions.inlay_hints").toggle_inlay_hints,
      { buffer = bufnr, desc = "Toggle inlay hints" },
    },
    ["<leader>wd"] = {
      function()
        require("telescope.builtin").lsp_document_symbols(telescope_themes.ivy)
      end,
      { buffer = bufnr, desc = "Document symbols" },
    },
    ["<leader>ww"] = {
      function()
        vim.ui.input({ prompt = "Query: " }, function(query)
          require("telescope.builtin").lsp_workspace_symbols(
            vim.tbl_deep_extend("force", telescope_themes.ivy, { query = query })
          )
        end)
      end,
      { buffer = bufnr, desc = "Workspace symbols" },
    },
    ["<leader>K"] = {
      lsp.peek_definition,
      { buffer = bufnr, desc = "Peek definition" },
    },
    gd = {
      vim.lsp.buf.definition,
      { buffer = bufnr, desc = "Definition" },
    },
    gi = {
      vim.lsp.buf.implementation,
      { buffer = bufnr, desc = "Implementation" },
    },
    gr = {
      vim.lsp.buf.references,
      { buffer = bufnr, desc = "References" },
    },
    gD = {
      vim.lsp.buf.declaration,
      { buffer = bufnr, desc = "Declaration" },
    },
    gT = {
      vim.lsp.buf.type_definition,
      { buffer = bufnr, desc = "Type definition" },
    },
    K = {
      vim.lsp.buf.hover,
      { buffer = bufnr, desc = "Hover" },
    },
  }
  for key, opts in pairs(mappings) do
    nnoremap(key, opts[1], opts[2])
  end

  local range_mappings = {
    ["<leader>ca"] = {
      function()
        require("telescope.builtin").lsp_range_code_actions(telescope_themes.cursor)
      end,
      { buffer = bufnr, desc = "Code actions" },
    },
    ["<leader>f"] = {
      vim.lsp.buf.range_formatting,
      { buffer = bufnr, desc = "Format" },
    },
  }

  for key, opts in pairs(range_mappings) do
    vnoremap(key, opts[1], opts[2])
  end
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = {
  dynamicRegistration = false,
}
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
updated_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local has_coq, coq = pcall(require, "coq")
if has_coq then
  updated_capabilities = coq.lsp_ensure_capabilities({ capabilities = updated_capabilities }).capabilities
end

local null_ls = require "null-ls"
local custom_sources = require "bombadil.lsp.null-ls"
null_ls.setup {
  debug = true,

  on_attach = on_attach,

  sources = {
    -- Formatting
    -- null_ls.builtins.formatting.clang_format, -- via clangd
    null_ls.builtins.formatting.cmake_format,
    -- null_ls.builtins.formatting.isort, -- via pylsp
    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.yapf, -- via pylsp
    -- Diagnostics
    null_ls.builtins.diagnostics.codespell.with { disabled_filetypes = { "firvish-job-output", "log" } },
    null_ls.builtins.diagnostics.luacheck.with {
      command = lsp_cmds.luacheck,
      extra_args = { "--globals", "vim", "--no-max-line-length" },
    },
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
    -- custom_sources.man.hover,
    -- Completion
    -- null_ls.builtins.completion.spell,
  },
}

null_ls.register {
  null_ls.builtins.diagnostics.cppcheck.with { filetypes = { "cpp" }, extra_args = { "--language", "cpp" } },
  null_ls.builtins.diagnostics.cppcheck.with { filetypes = { "c" }, extra_args = { "--language", "c" } },
}

-- local function disable_formatting(capabilities)
--   return vim.tbl_deep_extend("force", capabilities, {
--     textDocument = {
--       formatting = false,
--       rangeFormatting = false,
--     },
--   })
-- end

require("clangd_extensions").setup {
  server = {
    cmd = vim.list_extend(lsp_cmds.clangd, {
      "--background-index",
      "--header-insertion=iwyu",
      "--suggest-missing-includes",
    }),
    on_init = function(client)
      on_init(client)
      require("clang-format").setup(function(config)
        vim.bo.shiftwidth = config.IndentWidth
        vim.bo.textwidth = config.ColumnLimit
      end)
    end,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      nnoremap("<leader>a", function()
        require("bombadil.lib.clangd").switch_source_header(bufnr, true)
      end, { buffer = bufnr, desc = "Switch source/header" })
      require("clang-format").on_attach(client, bufnr)
    end,
    init_options = {
      clangdFileStatus = true,
      completeUnimported = true,
      semanticHighlighting = true,
      usePlaceholders = true,
    },
    -- HACK: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
    capabilities = vim.tbl_deep_extend("force", updated_capabilities, { offsetEncoding = { "utf-16" } }),
  },
}

lspconfig.cmake.setup {
  cmd = lsp_cmds.cmake,
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}

lspconfig.pylsp.setup {
  cmd = lsp_cmds.pylsp,
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
  settings = {
    ["pylsp.plugins.flake8.enable"] = true,
  },
}

lspconfig.sumneko_lua.setup(require("lua-dev").setup {
  lspconfig = {
    cmd = lsp_cmds.sumneko,
    on_init = on_init,
    on_attach = on_attach,
    capabilities = updated_capabilities,
    root_dir = function(fname)
      return lspconfig_util.find_git_ancestor(fname) or lspconfig_util.path.dirname(fname)
    end,
    globals = {
      -- Custom (see bombadil.globals)
      "P",
      "R",
      "RELOAD",
    },
  },
})

lspconfig.rnix.setup {
  cmd = lsp_cmds.rnix,
  on_init = on_init,
  on_attach = on_attach,
  capabilities = updated_capabilities,
}
