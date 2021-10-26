vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
  local packer = require "packer"
  local use = packer.use

  local local_use = function(opts)
    if type(opts) == "string" then
      local path = "~/dev/" .. opts
      opts = { path }
    elseif type(opts) == "table" then
      local path = "~/dev/" .. opts[1]
      opts[1] = path
    end

    use(opts)
  end

  -- Packer
  use "wbthomason/packer.nvim"

  -- Autoloading for lua
  use "tjdevries/astronauta.nvim"

  -- For when I forget what I'm doing
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  }
  use {
    "RishabhRD/nvim-cheat.sh",
    requires = "RishabhRD/popfix",
  }

  -- Movement, selection, search, etc
  use "ggandor/lightspeed.nvim"
  use "kshenoy/vim-signature"
  use {
    "mg979/vim-visual-multi",
    branch = "master",
  }

  -- Git
  use {
    "TimUntersberger/neogit",
    requires = "sindrets/diffview.nvim",
    config = function()
      require("neogit").setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  }
  use "lewis6991/gitsigns.nvim"
  use {
    "rhysd/git-messenger.vim",
    setup = function()
      vim.g.git_messenger_no_default_mappings = 1
    end,
  }
  use "tpope/vim-fugitive"
  use "ThePrimeagen/git-worktree.nvim"

  -- Development
  local_use {
    "make.nvim",
    config = function()
      local cwd = vim.fn.getcwd()
      require("make").setup {
        default = {
          exe = "cmake",
          source_dir = cwd,
          build_parallelism = 8,
          generator = "Ninja",
          open_quickfix_on_error = true,
        },
      }
    end,
    requires = { "akinsho/nvim-toggleterm.lua", "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    rocks = "luafilesystem",
  }
  use "neovim/nvim-lspconfig"
  use {
    "ms-jpq/coq_nvim",
    branch = "coq",
    requires = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
    setup = function()
      require "bombadil.config.coq"
    end,
  }
  use {
    "puremourning/vimspector",
    setup = function()
      vim.g.vimspector_enable_mappings = "HUMAN"
    end,
  }
  use "wbthomason/lsp-status.nvim"
  use "onsails/lspkind-nvim"
  use "nvim-lua/lsp_extensions.nvim"
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        auto_preview = false,
        auto_fold = true,
      }
    end,
  }
  use "folke/lua-dev.nvim"
  local_use {
    "refactoring.nvim",
    config = function()
      require("refactoring").setup()
    end,
    requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  }
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"
  use "theHamsta/nvim-dap-virtual-text"
  use "jbyuki/one-small-step-for-vimkind"

  -- Text editing + manipulation
  use "b3nj5m1n/kommentary"
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup {
        mappings_style = "surround",
        pairs = {
          nestable = {
            { "(", ")" },
            { "[", "]" },
            { "{", "}" },
            { "<", ">" },
          },
          linear = {
            { "'", "'" },
            { "`", "`" },
            { '"', '"' },
            { "*", "*" },
          },
        },
      }
    end,
  }
  use "windwp/nvim-autopairs"
  use {
    "mhartington/formatter.nvim",
    config = function()
      require "bombadil.config.formatter"
    end,
    rocks = "luafilesystem",
  }

  -- Treesitter/syntax/highlighty things
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  }
  use "hashivim/vim-terraform"
  use "kevinoid/vim-jsonc"
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        buftype_exclude = {
          "quickfix",
          "help",
          "prompt",
          "terminal",
        },
        filetype_exclude = {
          "man",
          "packer",
          "NeogitStatus",
          "NeogitCommitView",
          "NeogitLogView",
          "TelescopePrompt",
          "vimcmake",
        },
      }
    end,
  }
  use "zinit-zsh/zinit-vim-syntax"
  use {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("bqf").enable()
    end,
  }
  use "plasticboy/vim-markdown"
  use "LnL7/vim-nix"

  -- Visual stuff; sidebars, explorers, etc
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      vim.g.override_nvim_web_devicons = true
      require "nvim-nonicons"
    end,
    requires = "yamatsum/nvim-nonicons",
  }
  use {
    "folke/zen-mode.nvim",
    requires = "folke/twilight.nvim",
  }
  use {
    "folke/todo-comments.nvim",
    config = function()
      require "bombadil.config.todo"
    end,
  }
  use {
    "tamago324/lir.nvim",
    config = function()
      require "bombadil.config.lir"
    end,
    requires = { "nvim-lua/plenary.nvim", "yamatsum/nvim-nonicons" },
    rocks = { "inspect", "luafilesystem" },
  }
  use { "tamago324/lir-git-status.nvim", requires = "tamago324/lir.nvim" }
  use {
    "gelguy/wilder.nvim",
    config = function()
      require "bombadil.config.wild"
    end,
    requires = { "romgrk/fzy-lua-native" },
  }
  use "famiu/bufdelete.nvim"
  use "kazhala/close-buffers.nvim"

  -- Colors
  use "norcalli/nvim-colorizer.lua"
  use "tjdevries/express_line.nvim"
  use "tjdevries/colorbuddy.nvim"
  use "folke/tokyonight.nvim"

  -- Terminal integration
  use {
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  }
  use {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("toggleterm").setup()
    end,
  }

  -- Utilities
  use "nvim-lua/plenary.nvim"
  use "tpope/vim-eunuch"
  use "tpope/vim-repeat"
  use {
    "antoinemadec/FixCursorHold.nvim",
    run = function()
      vim.g.curshold_updatime = 1000
    end,
  }
  use "milisims/nvim-luaref"
  use {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup()
    end,
  }
  use {
    "ThePrimeagen/harpoon",
    config = function()
      require "bombadil.config.harpoon"
    end,
    requires = "nvim-lua/popup.nvim",
  }
  use "nathom/filetype.nvim"

  -- Telescope, et al
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-fzf-writer.nvim"
  use "nvim-telescope/telescope-packer.nvim"
  use "nvim-telescope/telescope-fzy-native.nvim"
  use "nvim-telescope/telescope-github.nvim"
  use "nvim-telescope/telescope-symbols.nvim"
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = "tami5/sql.nvim",
  }
  use "nvim-telescope/telescope-vimspector.nvim"
  use "nvim-telescope/telescope-project.nvim"

  -- Fzf
  use "junegunn/fzf"
  use {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup {
        winopts = {
          win_height = 0.3,
          win_width = 1,
          win_row = 1,
          win_col = 0.5,
        },
      }
    end,
    requires = {
      "vijaymarupudi/nvim-fzf",
    },
  }

  -- Note taking?
  use {
    "oberblastmeister/neuron.nvim",
    disable = true,
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  }
end)
