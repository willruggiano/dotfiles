{ lib, ... }:

with builtins;
with lib;
rec {
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);
}
