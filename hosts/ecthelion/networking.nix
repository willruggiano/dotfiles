{
  config,
  lib,
  ...
}: {
  networking = {
    firewall.allowedTCPPorts = lib.mkAfter [3001 4000];
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    interfaces.enp6s0.useDHCP = true;
    useDHCP = false;
  };
}
