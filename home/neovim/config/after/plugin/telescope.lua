local map_tele = require "bombadil.telescope.mappings"
local nnoremap = vim.keymap.nnoremap

local sorters = require "telescope.sorters"

map_tele("<space>gw", "grep_string", {
  short_path = true,
  word_match = "-w",
  only_sort_text = true,
  layout_strategy = "vertical",
  sorter = sorters.get_fzy_sorter(),
})
map_tele("<space>f/", "grep_last_search", {
  layout_strategy = "vertical",
})

-- Files
map_tele("<space>ft", "git_files")
map_tele("<space>fg", "live_grep")
map_tele("<space>fo", "oldfiles")
map_tele("<space>fd", "fd")
map_tele("<space>pp", "project_search")
map_tele("<space>fv", "find_nvim_source")
map_tele("<space>fe", "file_browser")
map_tele("<space>fz", "search_only_certain_files")

-- Git
map_tele("<space>gs", "git_status")
map_tele("<space>gc", "git_commits")

-- Nvim
map_tele("<space>fb", "buffers")
map_tele("<space>fa", "installed_plugins")
map_tele("<space>fi", "search_all_files")
map_tele("<space>ff", "curbuf")
map_tele("<space>fh", "help_tags")
map_tele("<space>vo", "vim_options")
map_tele("<space>gp", "grep_prompt")

map_tele("<space>en", "edit_neovim")
map_tele("<space>ez", "edit_zsh")
map_tele("<space>ed", "edit_dotfiles")

-- Telescope Meta
map_tele("<space>fB", "builtin")

-- Packer
nnoremap {
  "<space>fP",
  function()
    require("telescope").extensions.packer.plugins()
  end,
}
