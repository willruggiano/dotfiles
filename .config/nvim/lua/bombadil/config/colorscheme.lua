assert(vim.opt.termguicolors, "termguicolors must be set")

local now = os.date "*t"

if pcall(require, "awesome") then
  vim.cmd.colorscheme "awesome"
elseif pcall(require, "github-theme") then
  require("github-theme").setup()
elseif pcall(require, "catppuccin") then
  require("catppuccin").setup {
    flavour = (now.hour > 8 and now.hour < 16) and "latte" or "frappe",
    dim_inactive = {
      enabled = true,
    },
    integrations = {
      cmp = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      leap = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      neogit = true,
      notify = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
    styles = {
      comments = { "italic" },
      conditionals = {},
    },
  }

  vim.cmd.colorscheme "catppuccin"
end
