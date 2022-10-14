{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.kitty;
in {
  config = mkIf cfg.enable {
    user.packages = with pkgs; [kitty];

    programs.colorctl.settings = {
      kitty = {
        enable = true;
        reload-command = let
          cmd = pkgs.writeShellApplication {
            name = "reload-kitty-theme";
            runtimeInputs = with pkgs; [colorctl kitty procps];
            text = ''
              for pid in $(pgrep kitty-wrapped); do
                kitty @ --to unix:@kitty-"$pid" set-colors --all ~/.config/kitty/theme.conf
              done
            '';
          };
        in "${cmd}/bin/reload-kitty-theme";
      };
    };
  };
}
