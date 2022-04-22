{
  lib,
  stdenv,
  fetchFromGitHub,
  linkFarm,
  tree-sitter,
  writeTextFile,
}: let
  src = fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "3c50297eca950b4b1a7c07b28e586b0576c0a796";
    hash = "sha256-7KZa2L29g5pV0eC8rPh4wl6pz/Y3jbwKeFjDgn5peco=";
  };

  lockfile = builtins.fromJSON (builtins.readFile "${src}/lockfile.json");

  grammarName = drv: let
    name = lib.strings.getName drv;
  in
    lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" (lib.strings.removeSuffix "-${drv.version}" name));

  grammarRepo = drv: let
    name = lib.strings.getName drv;
  in
    lib.strings.removeSuffix "-grammar" (lib.strings.removeSuffix "-${drv.version}" name);

  mapGrammars = name: drv:
    lib.optionals (builtins.hasAttr name lockfile) {
      src = {
        repo = grammarRepo drv;
        rev = lockfile."${name}".revision;
      };
    };
  allGrammars = builtins.listToAttrs (map (drv: {
    name = grammarName drv;
    value = drv;
  })
  tree-sitter.allGrammars);
  builtGrammars = builtins.mapAttrs mapGrammars allGrammars;

  # TODO: What we have here is some json in which we've derived two of the four necessary arguments to fetchFromGitHub: repo and rev.
  # Next, we'll need to figure out the owner (somehow) and then finally determine the hash (by shelling out to nix-prefetch-hash, or whatever it is)
  grammars = writeTextFile {
    name = "grammars.json";
    text = builtins.toJSON builtGrammars;
  };
  # grammars =
  #   linkFarm "grammars"
  #   (map (drv: let
  #       name = lib.strings.getName drv;
  #     in {
  #       name = "parser/" + (lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" name))) + ".so";
  #       path = "${drv}/parser";
  #     })
  #     tree-sitter.allGrammars);
in
  stdenv.mkDerivation {
    name = "nvim-treesitter";

    inherit src;

    installPhase = ''
      mkdir $out
      cp -r {autoload,doc,lua,parser-info,plugin,queries} $out
      # cp -r ${grammars}/parser $out
      cp ${grammars} $out/grammars.json
    '';

    fixupPhase = ":";

    # passthru = {inherit grammars;};
  }
