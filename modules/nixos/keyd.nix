{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.keyd;
  settings_format = pkgs.formats.ini {};
in {
  options.services.keyd = with types; {
    enable = mkEnableOption "Enable keyd";
    settings = mkOption {
      description = "Attribute set of settings to add to default.conf";
      default = {};
      type = attrsOf (
        submodule {
          freeformType = attrsOf str;
        }
      );
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.keyd];
    user.extraGroups = ["keyd"];

    systemd.services.keyd = {
      enable = true;
      requires = ["local-fs.target"];
      after = ["local-fs.target"];
      wantedBy = ["default.target"];
      description = "keyd remapping daemon";
      serviceConfig = {
        ExecStart = "${pkgs.keyd}/bin/keyd";
        Restart = "always";
      };
    };

    environment.etc = {
      "keyd/default.conf".text = ''
        [ids]
        *

        include user
      '';

      "keyd/user".source = settings_format.generate "user.conf" cfg.settings;
    };
  };
}
