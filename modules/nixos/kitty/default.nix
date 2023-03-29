{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.kitty;
in {
  options.programs.kitty = {
    package = mkPackageOption pkgs "kitty" {};
  };

  config = mkIf cfg.enable {
    user.packages = [cfg.package];

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
