{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.suites.development;
  suites = literalExpression [
    "cxx"
    "json"
    "lua"
    "nix"
    "python"
    "qt"
    "shell"
  ];

  mkSuite = name: packages:
    mkIf ((isList cfg.suites && elem name cfg.suites) || cfg.suites == "all") {
      home.packages = packages;
    };
in
{
  options.suites.development = {
    enable = mkEnableOption "Enable selected development suites";
    suites = with types; mkOption {
      type = oneOf [ str (listOf str) ];
      default = [ ];
      description = "Specify which development suites to enable";
      example = literalExpression [ "cxx" "lua" "python" ];
    };
  };

  config = mkIf cfg.enable
    (mkMerge [
      (mkSuite "cxx" [
        # NOTE: These should come from project-specific shell.nix/flake.nix files!
        # pkgs.build2
        # pkgs.bpkg
        # pkgs.bdep
        pkgs.clang-tools
        # pkgs.cmake
        pkgs.cmake-format
        pkgs.cppcheck
        # pkgs.gnumake
        # pkgs.ninja
      ])
      (mkSuite "json" [
        pkgs.jq
        pkgs.nodePackages.prettier
        pkgs.yq
      ])
      (mkSuite "lua" [ pkgs.stylua ])
      (mkSuite "nix" [
        # pkgs.cached-nix-shell
        pkgs.nixpkgs-fmt
        pkgs.statix
      ])
      (mkSuite "python" [
        (pkgs.python39.withPackages (ps: with ps; [ isort pipx ]))
        pkgs.yapf
      ])
      (mkSuite "qt" [ pkgs.qtcreator ])
      (mkSuite "shell" [ pkgs.shellcheck pkgs.shfmt ])
      # Finally, some general tools which we always want:
      {
        home.packages = with pkgs; [
          codespell
        ];
      }
    ]);
}
