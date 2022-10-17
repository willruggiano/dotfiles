local ok, nix = pcall(require, "nix")
if not ok then
  return
end

require("nix").setup {
  xray = true,
}
