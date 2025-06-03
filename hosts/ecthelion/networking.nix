{config, ...}: {
  networking = {
    firewall.allowedTCPPorts = [5432];
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    interfaces.enp6s0.useDHCP = true;
    useDHCP = false;
  };
}
