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
    config = function()
      require "bombadil.config.cheat"
    end,
    cmd = { "Cheat" },
    keys = "?",
    requires = { "RishabhRD/popfix", module = "popfix" },
  }

  -- Movement, selection, search, etc
  use "ggandor/lightspeed.nvim"
  use {
    "chentau/marks.nvim",
    config = function()
      require "bombadil.config.marks"
    end,
  }
  use {
    "mg979/vim-visual-multi",
    branch = "master",
  }

  -- Git
  use {
    "TimUntersberger/neogit",
    config = function()
      require "bombadil.config.neogit"
    end,
    keys = { "<leader>g" },
    requires = "sindrets/diffview.nvim",
  }
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "bombadil.config.gitsigns"
    end,
  }
  use {
    "ThePrimeagen/git-worktree.nvim",
    setup = function()
      require "bombadil.config.git-worktree"
    end,
    keys = { "<leader>gw" },
    requires = "nvim-telescope/telescope.nvim",
  }
  use "tpope/vim-fugitive"
  use {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    fn = { "GitBlameToggle" },
    keys = { "<leader>gb" },
    setup = function()
      vim.g.gitblame_enabled = false
    end,
    config = function()
      require "bombadil.config.gitblame"
    end,
  }

  -- Development
  local_use {
    "make.nvim",
    config = function()
      require "bombadil.config.make"
    end,
    cond = function()
      return vim.fn.filereadable(vim.fn.expand "./makerc.lua")
    end,
    requires = { "akinsho/nvim-toggleterm.lua", "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    rocks = "luafilesystem",
  }
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "bombadil.lsp"
    end,
    event = "BufEnter *",
    module = { "lspconfig", "lspconfig.util" },
    requires = {
      { "wbthomason/lsp-status.nvim", module = "lsp-status" },
      { "onsails/lspkind-nvim", module = "lspkind" },
      "nvim-lua/lsp_extensions.nvim",
    },
  }
  use {
    "ms-jpq/coq_nvim",
    branch = "coq",
    event = "InsertEnter *",
    requires = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
    setup = function()
      require "bombadil.config.coq-setup"
    end,
    config = function()
      require "bombadil.config.coq"
    end,
  }
  use {
    "puremourning/vimspector",
    setup = function()
      vim.g.vimspector_enable_mappings = "HUMAN"
    end,
  }
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
    module = "dap",
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require "bombadil.config.dap-ui"
      end,
      module = "dapui",
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
    requires = { "rcarriga/nvim-notify", "Furkanzmc/firvish.nvim" },
  }

  -- Text editing + manipulation
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require "bombadil.config.comments"
    end,
    keys = { "<leader>c" },
    module = "kommentary",
  }
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require "bombadil.config.surround"
    end,
  }
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "bombadil.config.autopairs"
    end,
  }
  use {
    "mhartington/formatter.nvim",
    disable = true,
    config = function()
      require "bombadil.config.formatter"
    end,
    rocks = "luafilesystem",
  }
  use {
    "monaqa/dial.nvim",
    config = function()
      require "bombadil.config.dial"
    end,
    event = "BufEnter *",
  }

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
  use {
    "https://gitlab.com/yorickpeterse/nvim-pqf",
    config = function()
      require "bombadil.config.pqf"
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
  use {
    "tjdevries/express_line.nvim",
    config = function()
      require "bombadil.config.expressline"
    end,
  }
  use {
    "tjdevries/colorbuddy.nvim",
    module = "colorbuddy",
  }
  use {
    "folke/tokyonight.nvim",
    config = function()
      require "bombadil.config.tokyonight"
    end,
    requires = "norcalli/nvim-colorizer.lua",
  }

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
      require "bombadil.config.toggleterm"
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
  use "nathom/filetype.nvim"
  use "Furkanzmc/firvish.nvim"

  -- Telescope, et al
  use {
    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require "bombadil.config.telescope"
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      after = "telescope.nvim",
      run = "make",
    },
    { "nvim-telescope/telescope-github.nvim", after = "telescope.nvim" },
    { "nvim-telescope/telescope-packer.nvim", after = "telescope.nvim" },
    { "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" },
    {
      "nvim-telescope/telescope-frecency.nvim",
      after = "telescope.nvim",
      requires = "tami5/sql.nvim",
    },
    { "nvim-telescope/telescope-vimspector.nvim", after = "telescope.nvim" },
    { "nvim-telescope/telescope-project.nvim", after = "telescope.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim", after = "telescope.nvim" },
  }

  -- Fzf
  use "junegunn/fzf"
  use {
    "ibhagwan/fzf-lua",
    config = function()
      require "bombadil.config.fzf"
    end,
    module = "fzf-lua",
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
