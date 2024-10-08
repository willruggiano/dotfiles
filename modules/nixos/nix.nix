{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  documentation.dev.enable = true;

  environment = {
    shells = with pkgs; [bash fish zsh];
    systemPackages = with pkgs; [
      acpitool
      cowsay
      go-task
      man-pages
      man-pages-posix
      nix-output-monitor
      # nurl
      xdg-utils
    ];
    variables = {
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
    };
  };

  programs.command-not-found.enable = false;

  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
  system.stateVersion = lib.mkDefault "21.05";

  user = {
    extraGroups = [
      "wheel"
      (lib.optionalString config.hardware.i2c.enable config.hardware.i2c.group)
    ];
    isNormalUser = true;
    group = "users";
  };

  users.defaultUserShell = pkgs.fish;
}
