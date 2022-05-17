if vim.g.started_by_firenvim then
  vim.g.firenvim_config = {
    globalSettings = {
      alt = "all",
    },
    localSettings = {
      [".*"] = {
        cmdline = "neovim",
        priority = 0,
        selector = 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
        takeover = "always",
      },
      [ [[.*docs\.google\.com]] ] = {
        priority = 9,
        takeover = "never",
      },
      [ [[.*mail\.google\.com]] ] = {
        priority = 9,
        takeover = "never",
      },
    },
  }
end
