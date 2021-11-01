local ok, lightspeed = pcall(require, "lightspeed")
if not ok then
  lightspeed.setup {}
end
