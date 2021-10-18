{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.suites.development;
  suites = [
    "cxx"
    "json"
    "lua"
    "nix"
    "python"
  ];

  mkSuite = name: packages:
    mkIf ((elem name cfg.suites) || cfg.suites == "all") {
      home.packages = packages;
    };
in
{
  options = {
    suites.development = {
      enable = mkEnableOption "Enable selected development suites";
      suites = with types; mkOption {
        type = listOf str;
        default = [ ];
        description = "Specify which development suites to enable";
        example = [ "cxx" "lua" "python" ];
      };
    };
  };

  config = mkIf cfg.enable
    (mkMerge [
      (mkSuite "cxx" [ cmake clang-tools cmake-format gcc11 gnumake ninja ])
      (mkSuite "json" [ nodePackages.prettier ])
      (mkSuite "lua" [ stylua sumneko-lua-language-server ])
      (mkSuite "nix" [ nixpkgs-fmt rnix-lsp ])
      (mkSuite "python" [ (python39.withPackages (ps: with ps; [ isort pipx ])) python-language-server yapf ])
    ]);
}
