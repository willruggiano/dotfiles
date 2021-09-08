local config = require "kommentary.config"
local wk = require "which-key"

config.use_extended_mappings()

--[[ This function will be called automatically by the mapping, the first
argument will be the line that is being operated on. ]]
function insert_comment_below(...)
  local args = { ... }
  -- This includes the commentstring
  local configuration = config.get_config(0)
  local line_number = args[1]
  -- Get the current content of the line
  local content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
  --[[ Get the level of indentation of that line (Find the index of the
    first non-whitespace character) ]]
  local indentation = string.find(content, "%S")
  --[[ Create a string with that indentation, with a dot at the end so that
    kommentary respects that indentation ]]
  local new_line = string.rep(" ", indentation - 1) .. "."
  -- Insert the new line underneath the current one
  vim.api.nvim_buf_set_lines(0, line_number, line_number, false, { new_line })
  -- Comment in the new line
  require("kommentary.kommentary").comment_in_line(line_number + 1, configuration)
  -- Set the cursor to the correct position
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1] + 1, #new_line + 2 })
  -- Change the char under cursor (.)
  vim.api.nvim_feedkeys("cl", "n", false)
end

function insert_comment_above(...)
  local args = { ... }
  local configuration = config.get_config(0)
  local line_number = args[1]
  local content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
  local indentation = string.find(content, "%S")
  local new_line = string.rep(" ", indentation - 1) .. "."
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number - 1, false, { new_line })
  require("kommentary.kommentary").comment_in_line(line_number, configuration)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1] - 1, #new_line + 2 })
  vim.api.nvim_feedkeys("cl", "n", false)
end

config.add_keymap("n", "kommentary_insert_below", config.context.line, {}, "insert_comment_below")
config.add_keymap("n", "kommentary_insert_above", config.context.line, {}, "insert_comment_above")

wk.register {
  ["<leader>c"] = {
    name = "comment",
    k = { "<Plug>kommentary_insert_above", "above" },
    j = { "<Plug>kommentary_insert_below", "below" },
  },
}
