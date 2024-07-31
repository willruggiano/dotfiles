{config, ...}: {
  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    interfaces.wlp2s0.useDHCP = true;
    networkmanager.enable = true;
    useDHCP = false;
  };
}
