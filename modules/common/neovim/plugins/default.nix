{
  lib,
  pkgs,
}:
with pkgs.luajitPackages; let
  plugins = import ./nix/sources.nix {};
in {
  autopairs = {
    package = plugins.nvim-autopairs;
    config = ''
      require "bombadil.config.autopairs"
    '';
  };

  blankline = {
    package = plugins."indent-blankline.nvim";
    config = ''
      require "bombadil.config.indent-blankline"
    '';
  };

  bqf = {
    package = plugins.nvim-bqf;
    config = ''
      require "bombadil.config.bqf"
    '';
  };

  bufclose = {
    package = plugins."close-buffers.nvim";
  };

  bufdelete = {
    package = plugins."bufdelete.nvim";
  };

  cargo-expand = {
    package = plugins."cargo-expand.nvim";
  };

  clang-format = {
    # dev = "clang-format.nvim";
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
    config = ''
      require "bombadil.config.colorizer"
    '';
  };

  cpsm = {
    package = plugins.cpsm;
    override = with pkgs; {
      nativeBuildInputs = [cmake];
      buildInputs = [boost ncurses python3];
      buildPhase = ''
        cmake -S . -B build -DPY3:BOOL=ON
        cmake --build build --target install
      '';
    };
  };

  crates = {
    package = plugins."crates.nvim";
    config = ''
      require "bombadil.config.crates"
    '';
  };

  cursorhold = {
    package = plugins."fixcursorhold.nvim";
  };

  dap = {
    package = plugins.nvim-dap;
    config = ''
      require "bombadil.config.dap"
    '';
    rocks = [rapidjson];
  };

  dap-ui = {
    package = plugins.nvim-dap-ui;
    config = ''
      require "bombadil.config.dap-ui"
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
      vim.g.override_nvim_web_devicons = true
      require "nvim-nonicons"
    '';
  };

  dial = {
    package = plugins."dial.nvim";
    config = ''
      require "bombadil.config.dial"
    '';
  };

  diffview = {
    package = plugins."diffview.nvim";
  };

  docker-ui = {
    # package = pkgs.empty;
    package = pkgs."docker-ui-nvim";
    rocks = [lua-date];
    config = ''
      require "bombadil.config.docker-ui"
    '';
  };

  fidget = {
    package = plugins."fidget.nvim";
    config = ''
      require "bombadil.config.fidget"
    '';
  };

  firenvim = {
    package = pkgs.firenvim.plugin;
    config = ''
      require "bombadil.config.firenvim"
    '';
  };

  firvish = {
    # dev = "firvish.nvim";
    package = pkgs.firvish-nvim;
    config = ''
      require "bombadil.config.firvish"
    '';
  };

  firvish-buffers = {
    dev = "buffers.firvish";
    package = plugins."buffers.firvish";
  };

  firvish-git = {
    dev = "git.firvish";
    package = plugins."git.firvish";
  };

  firvish-jobs = {
    dev = "jobs.firvish";
    package = plugins."jobs.firvish";
  };

  nix-flake-prefetch = {
    # dev = "nix-flake-prefetch.nvim";
    package = pkgs.nix-flake-prefetch-nvim;
  };

  focus = {
    package = plugins."focus.nvim";
    config = ''
      require "bombadil.config.focus"
    '';
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
      require "bombadil.config.gitblame"
    '';
  };

  gitsigns = {
    package = plugins."gitsigns.nvim";
    config = ''
      require "bombadil.config.gitsigns"
    '';
  };

  harpoon = {
    package = plugins.harpoon;
    config = ''
      require "bombadil.config.harpoon"
    '';
  };

  impatient = {
    package = plugins."impatient.nvim";
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

  leap-flit = {
    package = plugins."flit.nvim";
  };

  # leap-spooky = {
  #   package = plugins."leap-spooky.nvim";
  # };

  lir = {
    package = plugins."lir.nvim";
    config = ''
      require "bombadil.config.lir"
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
      require "bombadil.config.lualine"
    '';
  };

  luaref = {
    package = plugins.nvim-luaref;
  };

  lush = {
    package = lua-lush.nvim-plugin;
  };

  markdown = {
    package = plugins.vim-markdown;
    config = ''
      require "bombadil.config.markdown"
    '';
  };

  marks = {
    package = plugins."marks.nvim";
    config = ''
      require "bombadil.config.marks"
    '';
  };

  neodev = {
    package = plugins."neodev.nvim";
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
      require "bombadil.config.neogit"
    '';
  };

  nix = {
    dev = "nix.nvim";
    package = plugins."nix.nvim";
    config = ''
      require "bombadil.config.nix"
    '';
  };

  nonicons = {
    package = plugins.nvim-nonicons;
  };

  notify = {
    package = plugins.nvim-notify;
    # NOTE: Do this in setup since it changes what vim.notify points to
    setup = ''
      require "bombadil.config.notify"
    '';
  };

  null-ls = {
    package = plugins."null-ls.nvim";
  };

  numb = {
    package = plugins."numb.nvim";
    config = ''
      require "bombadil.config.numb"
    '';
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

  plenary = {
    package = plugins."plenary.nvim";
  };

  popfix = {
    package = plugins.popfix;
  };

  refactoring = {
    package = plugins."refactoring.nvim";
  };

  repeat = {
    package = plugins.vim-repeat;
  };

  sourcegraph = {
    # dev = "sg.nvim";
    package = pkgs.sg-nvim;
  };

  statuscol = {
    package = plugins."statuscol.nvim";
    config = ''
      require "bombadil.config.statuscol"
    '';
  };

  surround = {
    package = plugins."surround.nvim";
    config = ''
      require "bombadil.config.surround"
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
      require "bombadil.config.telescope"
    '';
  };

  telescope-arecibo = {
    package = plugins."telescope-arecibo.nvim";
    rocks = [lua-openssl lua-http-parser];
  };

  telescope-docsets = {
    package = plugins."telescope-docsets.nvim";
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
      require "bombadil.config.git-worktree"
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
      require "bombadil.config.todo"
    '';
  };

  toggleterm = {
    package = plugins."toggleterm.nvim";
    config = ''
      require "bombadil.config.toggleterm"
    '';
  };

  treesitter = {
    package = pkgs.nvim-treesitter;
    config = ''
      require "bombadil.config.treesitter"
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

  undotree = {
    package = plugins.undotree;
    config = ''
      require "bombadil.config.undotree"
    '';
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

  which-key = {
    package = plugins."which-key.nvim";
    config = ''
      require "bombadil.config.which-key"
    '';
  };

  wilder = {
    package = plugins."wilder.nvim";
    config = ''
      require "bombadil.config.wilder"
    '';
  };

  xit = {
    package = plugins."xit.nvim";
    config = ''
      require "bombadil.config.xit"
    '';
  };

  zk = {
    package = plugins.zk-nvim;
    config = ''
      require "bombadil.config.zk"
    '';
  };
}
