local argparse = require "argparse"
local shipwright = require "shipwright"

local parser = argparse("colorctl", "Control system color(schemes)")
parser:argument("buildfile", "Shipwright buildfile")

local args = parser:parse()

shipwright.build(args.buildfile)
