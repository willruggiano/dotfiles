local telescope = require "telescope"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local _ = pcall(require, "nvim-nonicons")

local common_dirs = {
  ["~/.config"] = "conf",
  ["~/dev"] = "dev",
  ["~/dotfiles"] = "dot",
  ["~/notes"] = "notes",
  ["~/src"] = "src",
  ["~/workspaces"] = "work",
}
local frecency_workspaces = {}
local project_dirs = {}
for dir, abbr in pairs(common_dirs) do
  if vim.fn.isdirectory(dir) == 1 then
    frecency_workspaces[abbr] = vim.fn.expand(dir)
    table.insert(project_dirs, dir)
  end
end

telescope.setup {
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "* ",

    winblend = 0,

    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.85,
      -- preview_cutoff = 120,
      prompt_position = "top",

      horizontal = {
        -- width_padding = 0.1,
        -- height_padding = 0.1,
        preview_width = function(_, cols, _)
          if cols > 200 then
            return math.floor(cols * 0.4)
          else
            return math.floor(cols * 0.6)
          end
        end,
      },

      vertical = {
        -- width_padding = 0.05,
        -- height_padding = 1,
        width = 0.9,
        height = 0.95,
        preview_height = 0.5,
      },

      flex = {
        horizontal = {
          preview_width = 0.9,
        },
      },
    },

    selection_strategy = "reset",
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    color_devicons = true,

    mappings = {
      i = {
        ["<C-x>"] = false,
        ["<C-s>"] = actions.select_horizontal,

        ["<C-y>"] = set_prompt_to_entry_value,

        -- ["<M-m>"] = actions.master_stack,

        -- Experimental
        -- ["<tab>"] = actions.toggle_selection,

        -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },

    -- borderchars = { "-", "│", "-", "│", "+", "+", "+", "+" },

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },

    project = {
      base_dirs = project_dirs,
    },

    ["ui-select"] = {
      require("telescope.themes").get_ivy {
        winblend = 5,
      },
    },
  },
}

telescope.load_extension "dotfiles"
telescope.load_extension "fzf"
telescope.load_extension "git_worktree"
telescope.load_extension "project"
telescope.load_extension "ui-select"

if vim.fn.executable "gh" == 1 then
  telescope.load_extension "gh"
end

require("which-key").register {
  ["<space>d"] = {
    function()
      require("telescope").extensions.dotfiles.dotfiles()
    end,
    "dotfiles",
  },
  ["<space>e"] = {
    function()
      require("telescope.builtin").git_files()
    end,
    "git-files",
  },
  ["<space>p"] = {
    function()
      require("telescope").extensions.project.project {}
    end,
    "projects",
  },
  ["<leader>gh"] = {
    name = "hub",
    g = {
      function()
        require("telescope").extensions.gh.gist()
      end,
      "gists",
    },
    i = {
      function()
        require("telescope").extensions.gh.issues()
      end,
      "issues",
    },
    p = {
      function()
        require("telescope").extensions.gh.pull_request()
      end,
      "pull-requests",
    },
    w = {
      function()
        require("telescope").extensions.gh.run()
      end,
      "workflows",
    },
  },
}
