local function prettier()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
    stdin = true,
  }
end

local function clangformat()
  return {
    exe = "clang-format",
    args = { "--assume-filename=" .. vim.fn.expand "%:t" },
    cwd = vim.fn.expand "%:p:h",
    stdin = true,
  }
end

local function rustfmt()
  return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
end

local function yapf()
  return { exe = "yapf", stdin = true }
end

local function isort()
  return { exe = "isort", args = { "-", "--quiet" }, stdin = true }
end

local function latexindent()
  return { exe = "latexindent", args = { "-sl", "-g /dev/stderr", "2>/dev/null" }, stdin = true }
end

local function cmake_format()
  return { exe = "cmake-format", args = { vim.fn.expand "%:t" }, cwd = vim.fn.expand "%:p:h", stdin = false }
end

local function stylua()
  return { exe = "stylua", args = { "--search-parent-directories", "-" }, cwd = vim.fn.expand "%:p:h", stdin = true }
end

local function nixfmt()
  return { exe = "nixpkgs-fmt", stdin = true }
end

return {
  c = { clangformat },
  cmake = { cmake_format },
  cpp = { clangformat },
  html = { prettier },
  javascript = { prettier },
  json = { prettier },
  lua = { stylua },
  markdown = { prettier },
  nix = { nixfmt },
  python = { isort, yapf },
  rust = { rustfmt },
  tex = { latexindent },
  yaml = { prettier },
}
