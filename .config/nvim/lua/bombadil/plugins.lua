local packer = nil

local function init()
  if packer == nil then
    packer = require "packer"
    packer.init { disable_commands = true }
  end

  local use = packer.use
  local function local_use(opts)
    if type(opts) == "string" then
      local path = "~/dev/" .. opts
      opts = { path }
    elseif type(opts) == "table" then
      local path = "~/dev/" .. opts[1]
      opts[1] = path
    end

    use(opts)
  end
  packer.reset()

  -- Packer
  use "wbthomason/packer.nvim"

  -- Autoloading for lua
  use "tjdevries/astronauta.nvim"

  -- For when I forget what I'm doing
  use {
    "folke/which-key.nvim",
    config = function()
      require "bombadil.config.which-key"
    end,
  }
  use {
    "RishabhRD/nvim-cheat.sh",
    requires = "RishabhRD/popfix",
  }

  -- Movement, selection, search, etc
  use "ggandor/lightspeed.nvim"
  use {
    "chentau/marks.nvim",
    config = function()
      require("marks").setup {}
    end,
  }
  use {
    "mg979/vim-visual-multi",
    branch = "master",
  }

  -- Git
  use {
    "TimUntersberger/neogit",
    requires = "sindrets/diffview.nvim",
    config = function()
      require "bombadil.config.neogit"
    end,
  }
  use "lewis6991/gitsigns.nvim"
  use {
    "rhysd/git-messenger.vim",
    setup = function()
      vim.g.git_messenger_no_default_mappings = 1
    end,
  }
  use "ThePrimeagen/git-worktree.nvim"
  use "tpope/vim-fugitive"
  use {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    setup = function()
      vim.g.gitblame_enabled = false
    end,
  }

  -- Development
  local_use {
    "make.nvim",
    config = function()
      require "bombadil.config.make"
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
      require "bombadil.config.trouble"
    end,
  }
  use "folke/lua-dev.nvim"
  local_use {
    "refactoring.nvim",
    config = function()
      require "bombadil.config.refactoring"
    end,
    requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  }
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require "bombadil.config.dap"
    end,
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require "bombadil.config.dap-ui"
      end,
      requires = "mfussenegger/nvim-dap",
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      requires = "mfussenegger/nvim-dap",
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      requires = "mfussenegger/nvim-dap",
    },
  }
  use "jose-elias-alvarez/null-ls.nvim"
  local_use {
    "nix.nvim",
    config = function()
      require "bombadil.config.nix"
    end,
    requires = "rcarriga/nvim-notify",
  }

  -- Text editing + manipulation
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require "bombadil.config.comments"
    end,
  }
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require "bombadil.config.surround"
    end,
  }
  use "windwp/nvim-autopairs"
  use {
    "mhartington/formatter.nvim",
    disable = true,
    config = function()
      require "bombadil.config.formatter"
    end,
    rocks = "luafilesystem",
  }
  use "monaqa/dial.nvim"

  -- Treesitter/syntax/highlighty things
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "bombadil.config.treesitter"
    end,
    requires = {
      "David-Kunz/treesitter-unit",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
    },
  }
  use "hashivim/vim-terraform"
  use "kevinoid/vim-jsonc"
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "bombadil.config.indent-blankline"
    end,
  }
  use {
    "kevinhwang91/nvim-bqf",
    config = function()
      require "bombadil.config.bqf"
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
      require("terminal").setup {}
    end,
  }
  use {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("toggleterm").setup {}
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
      require "bombadil.config.numb"
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
  use "Furkanzmc/firvish.nvim"

  -- Telescope, et al
  use "nvim-telescope/telescope.nvim"
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use "nvim-telescope/telescope-github.nvim"
  use "nvim-telescope/telescope-packer.nvim"
  use "nvim-telescope/telescope-symbols.nvim"
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = "tami5/sql.nvim",
  }
  use "nvim-telescope/telescope-vimspector.nvim"
  use "nvim-telescope/telescope-project.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"

  -- Fzf
  use "junegunn/fzf"
  use {
    "ibhagwan/fzf-lua",
    config = function()
      require "bombadil.config.fzf"
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

  -- Firefox?
  use {
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  }
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
