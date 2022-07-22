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
    user.packages = [pkgs.kitty];

    systemd.user.services.apply-kitty-theme = {
      description = "Re-apply kitty theme";
      path = with pkgs; [kitty neovim];
      script = ''
        nvim --headless -c 'Shipwright ~/.config/kitty/shipwright.lua' -c q && kitty @ --to unix:@kitty set-colors --all ~/.config/kitty/theme.conf
      '';
    };

    systemd.user.timers.apply-kitty-theme = {
      description = "Re-apply kitty theme";
      partOf = ["apply-kitty-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
