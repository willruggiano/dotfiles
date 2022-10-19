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
    homebrew.casks = ["kitty"];

    programs.colorctl.settings = {
      kitty = {
        enable = true;
        reload-command = let
          cmd = pkgs.writeShellApplication {
            name = "reload-kitty-theme";
            runtimeInputs = with pkgs; [colorctl];
            text = ''
              shopt -s nullglob
              for sock in /tmp/kitty-*; do
                kitty @ --to "unix:$sock" set-colors --all ~/.config/kitty/theme.conf
              done
            '';
          };
        in "${cmd}/bin/reload-kitty-theme";
      };
    };
  };
}
