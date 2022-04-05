{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.karabiner;
in {
  options.programs.karabiner = {
    enable = mkEnableOption "Enable karabiner-elements";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["karabiner-elements"];
    home.configFile.karabiner = {
      source = ../../.config/karabiner;
      recursive = true;
    };
  };
}
