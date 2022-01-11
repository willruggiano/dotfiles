require("firvish").setup {
  keymaps = {
    buffers = {
      n = {
        zf = {
          function()
            local ft = vim.fn.input "> "
            require("firvish.buffers").filter_buffers(function(bufnr)
              local bufname = vim.fn.bufname(bufnr)
              return bufname:sub(-#ft) == ft
            end)
          end,
        },
        zm = {
          function()
            local pattern = vim.fn.input "> "
            require("firvish.buffers").filter_buffers(function(bufnr)
              local bufname = vim.fn.bufname(bufnr)
              if bufname:match(pattern) then
                return true
              else
                return false
              end
            end)
          end,
        },
      },
    },
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
