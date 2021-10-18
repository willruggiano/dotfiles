{ lib }:

dir: fn:
let
  inherit (builtins) attrValues concatLists readDir;
  inherit (lib) id filterAttrs hasPrefix mapAttrsToList mapModules mapModulesRec';
  dirs =
    mapAttrsToList
      (k: _: "${dir}/${k}")
      (filterAttrs
        (n: v: v == "directory" && !(hasPrefix "_" n))
        (readDir dir));
  files = attrValues (mapModules dir id);
  paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
in
map fn paths
