vim.g.coq_settings = {
  auto_start = "shut-up",
  clients = {
    buffers = {
      enabled = true,
    },
    lsp = {
      enabled = true,
    },
    snippets = {
      enabled = true,
      user_path = vim.env.DOTFILES .. "/.config/nvim/coq-user-snippets",
    },
    tmux = {
      enabled = false,
    },
    tree_sitter = {
      enabled = false,
    },
  },
  display = {
    preview = {
      border = {
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
        { "", "NormalFloat" },
      },
      positions = {
        east = 1,
        north = 2,
        west = 3,
        south = 4,
      },
    },
  },
}
