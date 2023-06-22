{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.htop;
in {
  options.programs.htop = {
    enable = mkEnableOption "htop";
    package = mkPackageOption "htop" pkgs {};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    home.configFile = {
      "htop/htoprc".text = ''
        fields=0 48 17 18 38 39 40 2 46 47 49 1
        show_program_path=1
      '';
    };
  };
}
