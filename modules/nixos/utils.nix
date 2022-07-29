{
  config,
  pkgs,
  ...
}: {
  config = {
    user.packages = with pkgs; [cached-nix-shell sysz];
  };
}
