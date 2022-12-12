vim.keymap.set("n", "<leader><leader>d", function()
  R("docker-ui").open()
end, { desc = "Docker" })
