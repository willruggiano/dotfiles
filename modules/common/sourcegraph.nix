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

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.src-cli];
    environment.interactiveShellInit = ''
      export SRC_ACCESS_TOKEN="$(cat ${config.age.secrets.sourcegraph.path})"
    '';
  };
}
