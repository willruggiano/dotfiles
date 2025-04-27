{pkgs, ...}: {
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
  environment.systemPackages = [pkgs.ollama-cuda];
  # services = {
  #   ollama = {
  #     enable = true;
  #     package = pkgs.ollama-cuda;
  #   };
  # };
}
