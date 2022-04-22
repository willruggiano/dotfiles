{
  fetchFromGitHub,
  fetchgit,
  lib,
  nix-prefetch-git,
  stdenv,
  tree-sitter,
  writeShellScriptBin,
  writeTextFile,
}: let
  src = fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "3c50297eca950b4b1a7c07b28e586b0576c0a796";
    hash = "sha256-7KZa2L29g5pV0eC8rPh4wl6pz/Y3jbwKeFjDgn5peco=";
  };

  # The grammar we care about:
  grammars = {
    bash = {
      owner = "tree-sitter";
    };
    c = {
      owner = "tree-sitter";
    };
    cmake = {
      owner = "uyha";
    };
    cpp = {
      owner = "tree-sitter";
    };
    dockerfile = {
      owner = "camdencheek";
    };
    go = {
      owner = "tree-sitter";
    };
    java = {
      owner = "tree-sitter";
    };
    javascript = {
      owner = "tree-sitter";
    };
    json = {
      owner = "tree-sitter";
    };
    json5 = {
      owner = "Joakker";
    };
    jsonc = rec {
      owner = "WhyNotHugo";
      url = "https://gitlab.com/${owner}/tree-sitter-jsonc";
    };
    lua = {
      owner = "MunifTanjim";
    };
    make = {
      owner = "alemuller";
    };
    markdown = {
      owner = "MDeiml";
    };
    nix = {
      owner = "cstrahan";
    };
    python = {
      owner = "tree-sitter";
    };
    query = {
      owner = "nvim-treesitter";
    };
    regex = {
      owner = "tree-sitter";
    };
    rust = {
      owner = "tree-sitter";
    };
    scheme = {
      owner = "6cdh";
    };
    toml = {
      owner = "ikatyang";
    };
    vim = rec {
      owner = "vigoux";
      repo = "tree-sitter-viml";
    };
    yaml = {
      owner = "ikatyang";
    };
  };

  lockfile = lib.importJSON "${src}/lockfile.json";

  getName = drv:
    lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" (lib.strings.removeSuffix "-${drv.version}" (lib.strings.getName drv)));

  allGrammars =
    builtins.mapAttrs (name: value: rec {
      inherit (value) owner;
      repo =
        if builtins.hasAttr "repo" value
        then value.repo
        else "tree-sitter-${name}";
      rev = lockfile."${name}".revision;
      url =
        if builtins.hasAttr "url" value
        then value.url
        else "https://github.com/${owner}/${repo}";
    })
    grammars;

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
    (lib.mapAttrsToList (k: v: {name = k;} // v) attrs);

  update-grammars = writeShellScriptBin "update-grammars.sh" ''
    set -euo pipefail
    out="/etc/nixos/packages/nvim-treesitter/grammars"
    mkdir -p "$out"
    ${
      foreachSh allGrammars ({
        name,
        url,
        rev,
        ...
      }: ''
        ${nix-prefetch-git}/bin/nix-prefetch-git \
          --quiet \
          --no-deepClone \
          --url "${url}" \
          --rev "${rev}" > $out/${name}.json'')
    }
  '';

  treesitterGrammars = map (name:
    stdenv.mkDerivation {
      name = "tree-sitter-${name}-grammar";
      src = let
        src = lib.importJSON "${toString ./.}/grammars/${name}.json";
      in
        fetchgit {
          inherit (src) url rev sha256;
        };

      buildInputs = [tree-sitter];

      dontUnpack = true;
      dontConfigure = true;

      CFLAGS = ["-I${src}/src" "-O2"];
      CXXFLAGS = ["-I${src}/src" "-O2"];

      buildPhase = ''
        runHook preBuild
        if [[ -e "$src/src/scanner.cc" ]]; then
              $CXX -c "$src/src/scanner.cc" -o scanner.o $CXXFLAGS
        elif [[ -e "$src/src/scanner.c" ]]; then
          $CC -c "$src/src/scanner.c" -o scanner.o $CFLAGS
        fi
        $CC -c "$src/src/parser.c" -o parser.o $CFLAGS
        $CXX -shared -o parser *.o
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir $out
        mv parser $out/
        runHook postInstall
      '';

      fixupPhase = lib.optionalString stdenv.isLinux ''
        runHook preFixup
        $STRIP $out/parser
        runHook postFixup
      '';

      passthru.parserName = name;
    }) (builtins.attrNames grammars);
in
  stdenv.mkDerivation {
    name = "nvim-treesitter";

    inherit src;

    installPhase = let
      knownGrammarsJson = writeTextFile {
        name = "known-grammars.json";
        text = builtins.toJSON allGrammars;
      };
    in
      lib.concatStringsSep "\n" (lib.lists.flatten ([
        "mkdir $out"
        "cp -r {autoload,doc,lua,parser-info,parser,plugin,queries} $out"
      ]
      ++ (map (drv: "cp ${drv}/parser $out/parser/${drv.parserName}.so") treesitterGrammars)));

    dontFixup = true;

    passthru = {inherit update-grammars;};
  }
