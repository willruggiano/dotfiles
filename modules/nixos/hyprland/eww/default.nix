{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.eww;
  eww-vol = pkgs.callPackage ./eww-vol.nix {};
in {
  options.programs.eww = {
    enable = mkEnableOption "Enable eww";
    package = mkPackageOption pkgs "eww-wayland" {};
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.eww-wayland];
    home.configFile = {
      eww-bar = {
        source = ./eww-bar;
        recursive = true;
      };

      "eww/eww.yuck".text = import ./eww.yuck.nix {inherit eww-vol pkgs;};
    };
  };
}
