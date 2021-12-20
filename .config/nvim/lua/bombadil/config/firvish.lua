require("firvish").setup {
  keymaps = {
    dir = {
      n = {
        ["<enter>"] = {
          function()
            local linenr = vim.fn.line "."
            local lines = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, true)
            vim.api.nvim_command("edit " .. lines[1])
          end,
        },
      },
    },
    history = {
      n = {
        ["-"] = false,
      },
    },
  },
}

require("which-key").register {
  ["<space>j"] = {
    function()
      require("firvish.job_control").show_jobs_list()
    end,
    "jobs",
  },
}

-- We have to manually do this since filetype.vim doesn't get sourced (because we use the
-- filetype.nvim plugin)
vim.cmd [[runtime ftdetect/firvish.lua]]
