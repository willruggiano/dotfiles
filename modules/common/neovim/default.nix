{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
  environment.systemPackages = lib.mkIf config.hardware.nvidia.enable [pkgs.ollama-cuda];
  # FIXME: doesn't find my GPU :/
  # services = {
  #   ollama = {
  #     enable = true;
  #     package = pkgs.ollama-cuda;
  #   };
  # };
}
