{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.suites.development;
  suites = literalExpression [
    "cxx"
    "json"
    "lua"
    "nix"
    "python"
  ];

  mkSuite = name: packages:
    mkIf ((isList cfg.suites && elem name cfg.suites) || cfg.suites == "all") {
      home.packages = packages;
    };
in
{
  options = {
    suites.development = {
      enable = mkEnableOption "Enable selected development suites";
      suites = with types; mkOption {
        type = oneOf [ str (listOf str) ];
        default = [ ];
        description = "Specify which development suites to enable";
        example = literalExpression [ "cxx" "lua" "python" ];
      };
    };
  };

  config = mkIf cfg.enable
    (mkMerge [
      (mkSuite "cxx" [ pkgs.cmake pkgs.clang-tools pkgs.cmake-format pkgs.gcc11 pkgs.gnumake pkgs.ninja ])
      (mkSuite "json" [ pkgs.jq pkgs.nodePackages.prettier pkgs.yq ])
      (mkSuite "lua" [ pkgs.stylua ])
      (mkSuite "nix" [ pkgs.nixpkgs-fmt pkgs.rnix-lsp ])
      (mkSuite "python" [ (pkgs.python39.withPackages (ps: with ps; [ isort pipx ])) pkgs.yapf ])
    ]);
}
