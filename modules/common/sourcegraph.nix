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
    user.packages = with pkgs; [src-cli];

    home.configFile = {
      "zsh/extra/19-sourcegraph.zsh".text = ''
        export SRC_ACCESS_TOKEN=$(cat ${config.age.secrets.sourcegraph.path})
      '';
    };
  };
}
