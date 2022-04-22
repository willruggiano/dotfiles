{
  lib,
  pkgs,
}:
with pkgs.luajitPackages; let
  plugins = import ./nix/sources.nix {};
in rec {
  autopairs = {
    package = plugins.nvim-autopairs;
    config = ''
      require "bombadil.config.autopairs";
    '';
  };

  blankline = {
    package = plugins."indent-blankline.nvim";
    config = ''
      require "bombadil.config.indent-blankline";
    '';
  };

  bqf = {
    package = plugins.nvim-bqf;
    config = ''
      require "bombadil.config.bqf";
    '';
  };

  bufclose = {
    package = plugins."close-buffers.nvim";
  };

  bufdelete = {
    package = plugins."bufdelete.nvim";
  };

  bufferline = {
    package = plugins."bufferline.nvim";
    config = ''
      require("bombadil.config.bufferline").setup()
    '';
  };

  clang-format = {
    package = plugins."clang-format.nvim";
    rocks = [lyaml];
  };

  clangd-extensions = {
    package = plugins."clangd_extensions.nvim";
  };

  cmp = {
    package = plugins.nvim-cmp;
    config = ''
      require "bombadil.config.cmp"
    '';
  };

  cmp-buffer = {
    package = plugins.cmp-buffer;
  };

  cmp-cmdline = {
    package = plugins.cmp-cmdline;
  };

  cmp-fuzzy-path = {
    package = plugins.cmp-fuzzy-path;
  };

  cmp-git = {
    package = plugins.cmp-git;
  };

  cmp-nvim-lsp = {
    package = plugins.cmp-nvim-lsp;
  };

  cmp-nvim-lsp-signature-help = {
    package = plugins.cmp-nvim-lsp-signature-help;
  };

  cmp-nvim-lua = {
    package = plugins.cmp-nvim-lua;
  };

  cmp-path = {
    package = plugins.cmp-path;
  };

  cmp-snippy = {
    package = plugins.cmp-snippy;
  };

  cmp-under-comparator = {
    package = plugins.cmp-under-comparator;
  };

  colorizer = {
    package = plugins."nvim-colorizer.lua";
  };

  cppman = {
    package = pkgs.cppman;
  };

  cpsm = {
    package = plugins.cpsm;
    override = {
      nativeBuildInputs = [pkgs.cmake];
      buildInputs = with pkgs; [boost ncurses python3];
      buildPhase = ''
        cmake -S . -B build -DPY3:BOOL=ON
        cmake --build build --target install
      '';
    };
  };

  cursorhold = {
    package = plugins."fixcursorhold.nvim";
  };

  dap = {
    package = plugins.nvim-dap;
    config = ''
      require "bombadil.config.dap";
    '';
    rocks = [rapidjson];
  };

  dap-ui = {
    package = plugins.nvim-dap-ui;
    config = ''
      require "bombadil.config.dap-ui";
    '';
  };

  dap-virtual-text = {
    package = plugins.nvim-dap-virtual-text;
  };

  devicons = {
    package = plugins.nvim-web-devicons;
    # HACK: We don't have much in 00-setup-plugins.lua, so we are safe in knowing that this will fire setup anything requires devicons or nvim-nonicons. But we probably want a more robust solution eventually.
    # This is really the only case where plugin ordering comes into play.
    setup = ''
      vim.g.override_nvim_web_devicons = true;
      require "nvim-nonicons";
    '';
  };

  dial = {
    package = plugins."dial.nvim";
    config = ''
      require "bombadil.config.dial";
    '';
  };

  diff-therapy = {
    # package = plugins."diff-therapy.nvim";
    package = pkgs.dummy;
    config = ''
      require "bombadil.config.diff-therapy";
    '';
  };

  diffview = {
    package = plugins."diffview.nvim";
  };

  eunuch = {
    package = plugins.vim-eunuch;
  };

  fidget = {
    package = plugins."fidget.nvim";
  };

  filetype = {
    package = plugins."filetype.nvim";
    config = ''
      require "bombadil.config.filetype";
    '';
  };

  firvish = {
    package = plugins."firvish.nvim";
    config = ''
      require "bombadil.config.firvish";
    '';
  };

  # TODO: Do I even use this anymore?
  fugitive = {
    package = plugins.vim-fugitive;
  };

  fuzzy = {
    package = plugins."fuzzy.nvim";
  };

  fzy-lua = {
    package = plugins.fzy-lua-native;
  };

  gitblame = {
    package = plugins."git-blame.nvim";
    setup = ''
      vim.g.gitblame_enabled = false
    '';
    config = ''
      require "bombadil.config.gitblame";
    '';
  };

  gitsigns = {
    package = plugins."gitsigns.nvim";
    config = ''
      require "bombadil.config.gitsigns";
    '';
  };

  kommentary = {
    package = plugins.kommentary;
    config = ''
      require "bombadil.config.comments"
    '';
  };

  leap = {
    package = plugins."leap.nvim";
    config = ''
      require "bombadil.config.leap"
    '';
  };

  lir = {
    package = plugins."lir.nvim";
    config = ''
      require "bombadil.config.lir";
    '';
    rocks = [luafilesystem];
  };

  lir-git-status = {
    package = plugins."lir-git-status.nvim";
  };

  lspconfig = {
    package = plugins.nvim-lspconfig;
    config = ''
      require "bombadil.config.lsp"
    '';
  };

  lspkind = {
    package = plugins.lspkind-nvim;
  };

  lsp-extensions = {
    package = plugins."lsp_extensions.nvim";
  };

  lualine = {
    package = plugins."lualine.nvim";
    config = ''
      require "bombadil.config.lualine";
    '';
  };

  luaref = {
    package = plugins.nvim-luaref;
  };

  lua-dev = {
    package = plugins."lua-dev.nvim";
  };

  lush = {
    package = plugins."lush.nvim";
  };

  make = {
    package = plugins."make.nvim";
    config = ''
      require "bombadil.config.make"
    '';
    rocks = [luafilesystem];
  };

  marks = {
    package = plugins."marks.nvim";
    config = ''
      require "bombadil.config.marks";
    '';
  };

  neogen = {
    package = plugins.neogen;
    config = ''
      require "bombadil.config.neogen"
    '';
  };

  neogit = {
    package = plugins.neogit;
    config = ''
      require "bombadil.config.neogit";
    '';
  };

  nix = {
    package = plugins."nix.nvim";
    config = ''
      require "bombadil.config.nix";
    '';
  };

  nonicons = {
    package = plugins.nvim-nonicons;
  };

  nortia = {
    package = plugins."nortia.nvim";
    config = ''
      require "bombadil.config.nortia"
    '';
  };

  notify = {
    package = plugins.nvim-notify;
    setup = ''
      require "bombadil.config.notify";
    '';
  };

  null-ls = {
    package = plugins."null-ls.nvim";
  };

  nvim-cheat = {
    package = plugins."nvim-cheat.sh";
    config = ''
      require "bombadil.config.cheat"
    '';
  };

  nvim-luadev = {
    package = plugins.nvim-luadev;
  };

  nvim-snippy = {
    package = plugins.nvim-snippy;
  };

  one-small-step-for-vimkind = {
    package = plugins.one-small-step-for-vimkind;
  };

  options = {
    package = plugins."options.nvim";
  };

  plenary = {
    package = plugins."plenary.nvim";
  };

  popfix = {
    package = plugins.popfix;
  };

  pqf = {
    package = plugins.nvim-pqf;
    config = ''
      require "bombadil.config.pqf";
    '';
  };

  refactoring = {
    package = plugins."refactoring.nvim";
  };

  repeat = {
    package = plugins.vim-repeat;
  };

  scope = {
    package = plugins."scope.nvim";
    config = ''
      require "bombadil.config.scope";
    '';
  };

  surround = {
    package = plugins."surround.nvim";
    config = ''
      require "bombadil.config.surround";
    '';
  };

  tabout = {
    package = plugins."tabout.nvim";
    config = ''
      require "bombadil.config.tabout"
    '';
  };

  telescope = {
    package = plugins."telescope.nvim";
    config = ''
      require "bombadil.config.telescope";
    '';
  };

  telescope-arecibo = {
    package = plugins."telescope-arecibo.nvim";
    rocks = [lua-openssl lua-http-parser];
  };

  telescope-fzf = {
    package = plugins."telescope-fzf-native.nvim";
    override = {
      buildPhase = "";
    };
  };

  telescope-github = {
    package = plugins."telescope-github.nvim";
  };

  telescope-symbols = {
    package = plugins."telescope-symbols.nvim";
  };

  telescope-project = {
    package = plugins."telescope-project.nvim";
  };

  telescope-ui-select = {
    package = plugins."telescope-ui-select.nvim";
  };

  telescope-worktree = {
    package = plugins."git-worktree.nvim";
    config = ''
      require "bombadil.config.git-worktree";
    '';
  };

  terminal = {
    package = plugins."nvim-terminal.lua";
    config = ''
      require("terminal").setup {}
    '';
  };

  todo = {
    package = plugins."todo-comments.nvim";
    config = ''
      require "bombadil.config.todo";
    '';
  };

  toggleterm = {
    package = plugins."toggleterm.nvim";
    config = ''
      require "bombadil.config.toggleterm";
    '';
  };

  treesitter = {
    package = plugins.nvim-treesitter;
    config = ''
      require "bombadil.config.treesitter";
    '';
  };

  treesitter-unit = {
    package = plugins.treesitter-unit;
  };

  treesitter-commentstring = {
    package = plugins.nvim-ts-context-commentstring;
  };

  treesitter-endwise = {
    package = plugins.nvim-treesitter-endwise;
  };

  treesitter-refactor = {
    package = plugins.nvim-treesitter-refactor;
  };

  treesitter-textobjects = {
    package = plugins.nvim-treesitter-textobjects;
  };

  treesitter-playground = {
    package = plugins.playground;
  };

  vim-snippets = {
    package = plugins.vim-snippets;
  };

  vimspector = {
    package = plugins.vimspector;
    setup = ''
      vim.g.vimspector_base_dir = vim.fn.stdpath("data") .. "/" .. "vimspector"
      vim.g.vimspector_enable_mappings = "HUMAN"
    '';
  };

  # When are we going to get a lua version of this? Or, even better!, builtin support?
  visual-multi = {
    package = plugins.vim-visual-multi;
  };

  which-key = {
    package = plugins."which-key.nvim";
    config = ''
      require "bombadil.config.which-key"
    '';
    override = {
      patches = [./which-key-253.patch];
    };
  };

  wilder = {
    package = plugins."wilder.nvim";
    config = ''
      require "bombadil.config.wilder"
    '';
  };

  zk = {
    package = plugins.zk-nvim;
    config = ''
      require "bombadil.config.zk"
    '';
  };
}
