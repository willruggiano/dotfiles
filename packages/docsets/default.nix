{
  buildEnv,
  callPackage,
  fetchurl,
  jq,
  lib,
  nix,
  stdenv,
  writeShellApplication,
}: let
  docsets = ["C" "C++" "CMake" "JavaScript" "Lua 5.1" "Lua 5.4" "Python 3" "Rust" "TypeScript"];

  foreachSh = langs: f: lib.concatMapStringsSep "\n" f langs;
  update-docsets = writeShellApplication {
    name = "update-docsets";
    runtimeInputs = [jq nix];
    text = ''
      # NOTE: $1 is the path to this directory
      out="$1/docsets"
      mkdir -p "$out"
      ${
        foreachSh docsets (lang: let
          lang' = builtins.replaceStrings [" "] ["_"] lang;
          url = "http://sanfrancisco.kapeli.com/feeds/${lang'}.tgz";
        in ''
          echo "Updating docset for ${lang}"
          echo "{\"url\": \"${url}\", \"sha256\": \"$(nix-prefetch-url --type sha256 ${url})\"}" | jq > "$out/${lang'}.json"
        '')
      }
    '';
  };

  docsetDrvs =
    [(callPackage ./postgresql.docset.nix {})]
    ++ map (lang: let
      lang' = builtins.replaceStrings [" "] ["_"] lang;
    in
      stdenv.mkDerivation {
        name = "${lang}-docset";
        src = let
          src' = lib.importJSON "${toString ./.}/docsets/${lang'}.json";
        in
          fetchurl {inherit (src') url sha256;};

        installPhase = ''
          mkdir -p $out/share/docsets
          cp -r . $out/share/docsets/${lang'}.docset
        '';

        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;
      })
    docsets;
in
  buildEnv {
    name = "docsets";
    paths = docsetDrvs;
    passthru = {
      inherit update-docsets;
      docsets = builtins.listToAttrs (builtins.map (drv: lib.nameValuePair drv.name drv) docsetDrvs);
    };
  }
