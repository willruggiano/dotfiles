{ lib, ... }:

dir: fn:
let
  inherit (builtins) attrValues;
  inherit (lib) mapModules;
in
attrValues (mapModules dir fn)
