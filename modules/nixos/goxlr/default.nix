{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.goxlr;
in {
  options.services.goxlr = {
    enable = mkEnableOption "GoXLR daemon";
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.goxlr];

    # home.configFile = {
    #   "goxlr-utility/settings.json".text =
    #     builtins.toJSON {
    #       profile_directory = "/home/${config.user.name}/.local/share/goxlr-utility/profiles";
    #       mic_profile_directory = "/home/${config.user.name}/.local/share/goxlr-utility/mic-profiles";
    #       samples_directory = "/home/${config.user.name}/.local/share/goxlr-utility/samples";
    #       devices = {};
    #     };
    # };

    services.udev.packages = [pkgs.goxlr.goxlr-udev-rules];

    systemd.user.services.goxlr = {
      description = "GoXLR daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.goxlr}/bin/goxlr-daemon";
      };
    };
  };
}
