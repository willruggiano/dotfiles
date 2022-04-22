{
  lib,
  linkFarm,
  nvim-treesitter,
  tree-sitter,
}: let
  inherit (tree-sitter) allGrammars;
  grammars =
    linkFarm "treesitter-grammars"
    (map (drv: let
      name = lib.strings.getName drv;
    in {
      name = "parser/" + (lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" name))) + ".so";
      path = "${drv}/parser";
    })
    allGrammars);
in
  nvim-treesitter
