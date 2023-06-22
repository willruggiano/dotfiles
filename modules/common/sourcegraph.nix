{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sourcegraph;
in {
  options.programs.sourcegraph = {
    enable = mkEnableOption "Enable sourcegraph";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [pkgs.src-cli];
    }
    (mkIf config.programs.fish.enable {
      programs.fish.interactiveShellInit = ''
        set -gx SRC_ACCESS_TOKEN $(cat ${config.age.secrets.sourcegraph.path})
      '';
    })
  ]);
}
