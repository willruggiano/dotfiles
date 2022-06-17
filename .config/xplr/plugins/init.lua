require("fzf").setup {
  mode = "default",
  key = "F",
  args = os.getenv "FZF_DEFAULT_OPTS",
}

require("icons").setup()
require("neomutt").setup()
require("qrcp").setup()
