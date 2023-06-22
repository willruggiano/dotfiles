{
  config,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [cached-nix-shell sysz];
  };
}
