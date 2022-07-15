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
      user_path = vim.env.DOTFILES .. "/.config/nvim/snippets",
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
        north = 4,
        east = 1,
        west = 2,
        south = 3,
      },
    },
  },
  keymap = {
    recommended = false,
    bigger_preview = "<C-/>",
    jump_to_mark = "",
  },
  xdg = true,
}
