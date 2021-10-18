{ lib }:

dir: fn:
let
  inherit (builtins) readDir;
  inherit (lib) hasPrefix hasSuffix mapFilterAttrs mapModulesRec nameValuePair removeSuffix;
in
mapFilterAttrs
  (n: v:
    v != null &&
    !(hasPrefix "_" n))
  (n: v:
    let path = "${toString dir}/${n}"; in
    if v == "directory"
    then nameValuePair n (mapModulesRec path fn)
    else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
    then nameValuePair (removeSuffix ".nix" n) (fn path)
    else nameValuePair "" null)
  (readDir dir)
