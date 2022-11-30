{
  fetchFromGitHub,
  fetchgit,
  fetchpatch,
  lib,
  nix-prefetch-git,
  stdenv,
  tree-sitter,
  writeShellApplication,
}: let
  src = fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "18cc1216e128b2db1046cf7b3a46851c7c4e4073";
    hash = "sha256-nms+gvbuvVR4gic04a9miwNdMGQYANxXLDuSHSO6QS8=";
  };

  # The grammars we care about:
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
      # NOTE: This patch provides support for several C++20 features, e.g. modules
      # override = {
      #   patches = [
      #     (fetchpatch {
      #       url = "https://github.com/tree-sitter/tree-sitter-cpp/pull/173.diff";
      #       hash = "sha256-HoL3cwgSrgqdFgTSbTKGdSHfycXJd60mwiUZssyaL8w=";
      #     })
      #   ];
      # };
    };
    dockerfile = {
      owner = "camdencheek";
    };
    go = {
      owner = "tree-sitter";
    };
    html = {
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
    jsonnet = {
      owner = "sourcegraph";
    };
    lua = {
      owner = "MunifTanjim";
    };
    make = {
      owner = "alemuller";
    };
    markdown = {
      owner = "MDeiml";
      sourceRoot = "tree-sitter-markdown";
    };
    markdown_inline = {
      owner = "MDeiml";
      repo = "tree-sitter-markdown";
      sourceRoot = "tree-sitter-markdown-inline";
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
    sql = {
      owner = "DerekStride";
    };
    toml = {
      owner = "ikatyang";
    };
    vim = {
      owner = "vigoux";
      repo = "tree-sitter-viml";
    };
    xit = {
      owner = "synaptiko";
      rev = "0.1";
    };
    yaml = {
      owner = "ikatyang";
    };
    zig = {
      owner = "maxxnino";
    };
  };

  lockfile = lib.importJSON "${src}/lockfile.json";

  getName = drv:
    lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" (lib.strings.removeSuffix "-${drv.version}" (lib.strings.getName drv)));

  allGrammars =
    builtins.mapAttrs (name: value: rec {
      inherit (value) owner;
      repo =
        if value ? "repo"
        then value.repo
        else "tree-sitter-${name}";
      rev =
        if value ? "rev"
        then value.rev
        else lockfile."${name}".revision;
      url =
        if value ? "url"
        then value.url
        else "https://github.com/${owner}/${repo}";
    })
    grammars;

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
    (lib.mapAttrsToList (k: v: {name = k;} // v) attrs);

  update-grammars = writeShellApplication {
    name = "update-grammars.sh";
    runtimeInputs = [nix-prefetch-git];
    text = ''
      out="''${1:-/etc/nixos}/packages/nvim-treesitter/grammars"
      mkdir -p "$out"
      ${
        foreachSh allGrammars ({
          name,
          url,
          rev,
          ...
        }: ''
          echo "Updating treesitter parser for ${name}"
          ${nix-prefetch-git}/bin/nix-prefetch-git \
            --quiet \
            --no-deepClone \
            --url "${url}" \
            --rev "${rev}" > "$out"/${name}.json'')
      }
    '';
  };

  treesitterGrammars = lib.mapAttrsToList (name: attrs:
    stdenv.mkDerivation ({
      name = "tree-sitter-${name}-grammar";
      src = let
        src' = lib.importJSON "${toString ./.}/grammars/${name}.json";
      in
        fetchgit {
          inherit (src') url rev sha256;
        };

      buildInputs = [tree-sitter];

      CFLAGS = ["-Isrc" "-O2"];
      CXXFLAGS = ["-Isrc" "-O2"];

      dontConfigure = true;

      buildPhase = lib.concatStringsSep "\n" [
        "runHook preBuild"
        (
          if attrs ? "sourceRoot"
          then "cd ${attrs.sourceRoot}"
          else ""
        )
        ''
          if [[ -e "src/scanner.cc" ]]; then
                $CXX -c "src/scanner.cc" -o scanner.o $CXXFLAGS
          elif [[ -e "src/scanner.c" ]]; then
            $CC -c "src/scanner.c" -o scanner.o $CFLAGS
          fi
          $CC -c "src/parser.c" -o parser.o $CFLAGS
          $CXX -shared -o parser *.o
          runHook postBuild
        ''
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/queries
        mv parser $out/
        for f in queries/**/*.scm; do
          cp $f $out/queries/$(basename $f)
        done
        runHook postInstall
      '';

      fixupPhase = lib.optionalString stdenv.isLinux ''
        runHook preFixup
        $STRIP $out/parser
        runHook postFixup
      '';

      passthru.parserName = name;
    }
    // attrs.override or {}))
  grammars;
in
  stdenv.mkDerivation {
    name = "nvim-treesitter";

    inherit src;

    installPhase = lib.concatStringsSep "\n" (lib.lists.flatten ([
      "mkdir $out"
      "cp -r {autoload,doc,lua,parser-info,parser,plugin,queries} $out"
    ]
    ++ (map (drv: ''
      cp ${drv}/parser $out/parser/${drv.parserName}.so
      for f in ${drv}/queries/*.scm; do
        cp $f $out/queries/${drv.parserName}/$(basename $f)
      done
    '')
    treesitterGrammars)));

    dontFixup = true;

    passthru = {inherit update-grammars;};
  }
