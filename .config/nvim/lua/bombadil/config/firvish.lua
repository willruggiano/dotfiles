require("firvish").setup {
  create_user_commands = true,
  keymaps = {
    buffers = {
      n = {
        ["-"] = false,
        ["dd"] = {
          function()
            local line = vim.fn.line "."
            require("firvish.buffers").delete_buffers(line, line, true)
          end,
          { desc = "[firvish] Delete buffer" },
        },
        ["zp"] = {
          function()
            local pattern = vim.fn.input "> "
            require("firvish.buffers").filter_buffers(function(buffer)
              local bufname = buffer:name()
              if bufname:match(pattern) then
                return true
              else
                return false
              end
            end)
          end,
          { desc = "[firvish] Filter buffers (pattern)" },
        },
        ["zt"] = {
          function()
            local ft = vim.fn.input "> "
            require("firvish.buffers").filter_buffers(function(buffer)
              local bufname = buffer:name()
              return bufname:sub(-#ft) == ft
            end)
          end,
          { desc = "[firvish] Filter buffers (filetype)" },
        },
      },
      v = {
        ["d"] = {
          function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
            local start_line = vim.fn.line "'<"
            local end_line = vim.fn.line "'>"
            require("firvish.buffers").delete_buffers(start_line, end_line, true)
          end,
          { desc = "[firvish] Delete buffers" },
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
          { desc = "[firvish] Open file" },
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
  require("firvish.buffers").open_buffer_list()
end, { desc = "Buffers" })

nnoremap("<space>h", function()
  require("firvish.history").open_history()
end, { desc = "History" })

nnoremap("<space>j", function()
  require("firvish.job_control").show_jobs_list()
end, { desc = "Jobs" })

vim.cmd [[runtime ftdetect/firvish.lua]]
