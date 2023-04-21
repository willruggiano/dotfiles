{config, ...}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager.enable = true;
}
