require("firvish").setup {
  keymaps = {
    buffers = {
      n = {
        ["-"] = false,
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
        ["-"] = false,
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

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<space>b", function()
  require("firvish.buffers").open_buffers()
end, { desc = "Buffers" })

nnoremap("<space>h", function()
  require("firvish.history").open_history()
end, { desc = "History" })

nnoremap("<space>j", function()
  require("firvish.job_control").show_jobs_list()
end, { desc = "Jobs" })

vim.cmd [[runtime ftdetect/firvish.lua]]
