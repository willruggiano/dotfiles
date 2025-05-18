{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.weechat;
in {
  options.programs.weechat = {
    enable = mkEnableOption "Enable weechat";
  };

  config = let
    package = pkgs.weechat.override {
      configure = {availablePlugins, ...}: {
        scripts = with pkgs.weechatScripts; [
          autosort
          colorize_nicks
          highmon
          wee-slack
          weechat-go
          weechat-grep
          weechat-notify-send
        ];
      };
    };
  in
    mkIf cfg.enable {
      environment.systemPackages = [package];
      home.configFile = {
        "weechat/weechat.conf".source = ./weechat.conf;
      };
      home.dataFile = {
        "weechat/python/autoload/theme.py".source = ./theme.py;
      };
    };
}
