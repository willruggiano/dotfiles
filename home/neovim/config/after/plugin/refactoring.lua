local refactoring = require "refactoring"
local actions = require "telescope.actions"
local config = require "telescope.config"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local state = require "telescope.actions.state"
local themes = require "telescope.themes"
local wk = require "which-key"

local function refactor(prompt_bufnr)
  local content = state.get_selected_entry(prompt_bufnr)
  actions.close(prompt_bufnr)
  refactoring.refactor(content.value)
end

local function refactors()
  local opts = themes.get_cursor()
  pickers.new(opts, {
    prompt_title = "refactors",
    finder = finders.new_table {
      results = refactoring.get_refactors(),
    },
    sorter = config.values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<cr>", refactor)
      map("n", "<cr>", refactor)
      return true
    end,
  }):find()
end

local mappings = {
  ["<leader>r"] = {
    name = "refactor",
    e = {
      function()
        refactoring.refactor "Extract Function"
      end,
      "extract-function",
    },
    f = {
      function()
        refactoring.refactor "Extract Function To File"
      end,
      "extract-function-file",
    },
    r = {
      function()
        local keys = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        vim.api.nvim_feedkeys(keys, "v", true)
        refactors()
      end,
      "refactors",
    },
  },
}
wk.register(mappings, { mode = "v" })
