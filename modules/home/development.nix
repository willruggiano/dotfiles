{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.suites.development;
  suite = types.enum [
    "all"
    "cxx"
    "json"
    "lua"
    "nix"
    "python"
    "qt"
    "shell"
    "zigmod"
  ];

  suiteEnabled = name: (isList cfg.suites && elem name cfg.suites) || cfg.suites == "all";

  mkSuite = name: packages:
    mkIf (suiteEnabled name) {
      home.packages = packages;
    };
in {
  options.suites.development = {
    enable = mkEnableOption "Enable selected development suites";
    suites = with types;
      mkOption {
        type = oneOf [suite (listOf suite)];
        default = [];
        description = "Specify which development suites to enable";
        example = literalExpression ["cxx" "lua" "python"];
      };
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      (mkSuite "cxx" [
        pkgs.cmake-format
      ])
      (mkSuite "json" [
        pkgs.jq
        pkgs.nodePackages.prettier
        pkgs.yq
      ])
      (mkSuite "lua" [
        pkgs.luajitPackages.luacheck
        pkgs.stylua
      ])
      (mkSuite "nix" [
        pkgs.alejandra
        pkgs.statix
      ])
      (mkSuite "python" [
        (pkgs.python3.withPackages (ps: with ps; [isort pipx]))
        pkgs.yapf
      ])
      (mkSuite "qt" [pkgs.qtcreator])
      (mkSuite "shell" [pkgs.shellcheck pkgs.shfmt])
      (mkSuite "zig" [pkgs.zigmod])
      # Finally, some general tools which we always want:
      {
        home.packages = with pkgs; [
          codespell
        ];
      }
    ]);
}
