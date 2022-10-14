local argparse = require "argparse"
local inspect = require "inspect"

local function debug(args, message)
  if args.debug then
    print(inspect(message))
  end
end

local utils = require "colorctl.utils"

local parser = argparse("colorctl", "Control system color(schemes)")
parser:flag("--debug", "Debug mode")

local build = parser:command("build", "Rebuild (and re-apply) color configuration for a specific application")
build:argument "application"
build:option("--override-hour", "Override the hour used to compute the color configuration")
build:flag("--reload", "Re-apply the color configuration for a specific application")
build:option("--reload-command", "The command to run to reload the application-specific colorscheme")
build:action(function(args, _)
  debug(args, args)

  package.loaded["awesome"] = nil
  local theme = require "awesome.theme"

  if args.override_hour ~= nil then
    theme.set_hour(tonumber(args.override_hour))
  end

  require("colorctl." .. args.application).run(args)

  if args.reload then
    assert(args["reload-command"], "must have a reload-command for " .. args.application)
    os.execute(utils.gsubenv(args["reload-command"]))
  end
end)

parser:parse()
