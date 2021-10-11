{ options, config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.desktop.mutt;
in
{
  options.modules.desktop.mutt = {
    enable = mkEnableOption "Enable mutt";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      neomutt
    ];

    home.configFile = {
      "mutt/neomuttrc".source = ../../.config/mutt/neomuttrc;
    };
  };
}
