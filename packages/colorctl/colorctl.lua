local argparse = require "argparse"
local io = require "std.io"
local inspect = require "inspect"
local lfs = require "lfs"
local toml = require "toml"

local function debug(args, message)
  if args.debug then
    print(inspect(message))
  end
end

local utils = require "colorctl.utils"

local parser = argparse("colorctl", "Control system color(schemes)")
parser
  :option("-c --config", "Path to config file", os.getenv "HOME" .. "/.config/colorctl/config.toml")
  :convert(function(filename)
    filename = utils.gsubenv(filename)
    if not lfs.attributes(filename) then
      return {}
    end
    local config = io.slurp(filename)
    return toml.parse(config)
  end)
parser:flag("--debug", "Debug mode")

local build = parser:command("build", "Rebuild (and re-apply) color configuration for a specific application")
build:argument "application"
build:option("--override-hour", "Override the hour used to compute the color configuration")
build:action(function(args, _)
  debug(args, args)

  package.loaded["awesome"] = nil
  local theme = require "awesome.theme"

  if args.override_hour ~= nil then
    theme.set_hour(tonumber(args.override_hour))
  end

  local config = utils.tbl_merge(args.config[args.application] or {}, { override_hour = args.override_hour })
  require("colorctl." .. args.application).run(config)
end)

parser:parse()
