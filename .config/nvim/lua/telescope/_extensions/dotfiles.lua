local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This plugin requires telescope.nvim"
end

local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"

local Job = require "plenary.job"

local dotfiles = function(opts)
  assert(vim.env.DOTFILES, "$DOTFILES must be set")
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "~ dotfiles ~",
    finder = finders._new {
      fn_command = function(_, prompt)
        return {
          writer = Job:new {
            command = "rg",
            args = { "--files", vim.env.DOTFILES },
          },
          command = "fzf",
          args = { "--filter", prompt },
        }
      end,
      entry_maker = make_entry.gen_from_file(opts),
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
  }):find()
end

return telescope.register_extension {
  exports = {
    dotfiles = dotfiles,
  },
}
