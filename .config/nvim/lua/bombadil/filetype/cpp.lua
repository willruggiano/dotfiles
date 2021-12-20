local wk = require "which-key"

wk.register({
  ["<leader>d"] = {
    s = {
      name = "start",
      ["<tab>"] = { require("telescope").extensions.vimspector.configurations, "select" },
      ["<cr>"] = {
        function()
          local target = vim.g.dap_target
          if target ~= nil then
            vim.fn["vimspector#LaunchWithSettings"] { configuration = target }
          else
            vim.fn["vimspector#Continue"]()
          end
        end,
        "default",
      },
    },
    x = {
      function()
        vim.fn["vimspector#Reset"]()
      end,
      "kill",
    },
  },
}, {
  buffer = 0,
})
