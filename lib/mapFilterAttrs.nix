{ lib, ... }:

pred: f: attrs:
let
  inherit (lib) filterAttrs mapAttrs';
in
filterAttrs pred (mapAttrs' f attrs)
