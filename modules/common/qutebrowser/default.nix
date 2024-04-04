{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.qutebrowser;
in {
  options.programs.qutebrowser = with types; {
    enable = mkEnableOption "Enable qutebrowser";
    package = mkPackageOption pkgs "qutebrowser" {};
    default = mkEnableOption "Make qutebrowser the default browser";
    dicts = mkOption {
      type = listOf str;
      default = ["en-US"];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [cfg.package];
      # https://github.com/qutebrowser/qutebrowser/issues/8154#issuecomment-2032510578
      environment.variables.QT_OPENGL_NO_SANITY_CHECK = "1";

      programs.flavours.items.qutebrowser = {
        template = "${pkgs.base16-templates}/templates/qutebrowser/templates/default.mustache";
      };

      home.configFile = {
        "qutebrowser/config.py".text = import ./config.py.nix {inherit config pkgs;};
        "qutebrowser/userscripts/autorefresh".source = import ./autorefresh.py.nix {inherit pkgs;};
      };
    }
    (mkIf cfg.default {
      environment.variables.BROWSER = "qutebrowser";
    })
  ]);
}
