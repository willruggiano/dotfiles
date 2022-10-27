{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.keyd;
in {
  options.services.keyd = {
    enable = mkEnableOption "Enable keyd";
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

        [main]

        # Turns capslock into an escape key when pressed and a control key when held.
        capslock = overload(control, esc)

        # Remaps the escape key to capslock
        esc = capslock
      '';
    };
  };
}
