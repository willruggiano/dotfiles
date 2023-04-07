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
    default = mkEnableOption "Make qutebrowser the default browser";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.flavours.items.qutebrowser = {
        template = "${pkgs.base16-templates}/templates/qutebrowser/templates/default.mustache";
      };

      home.configFile = {
        "qutebrowser/config.py".text = import ./config.py {inherit config pkgs;};
        "qutebrowser/userscripts/autorefresh".source = import ./autorefresh.py.nix {inherit pkgs;};
      };
    }
    (mkIf cfg.default {
      environment.variables.BROWSER = "qutebrowser";
    })
  ]);
}
