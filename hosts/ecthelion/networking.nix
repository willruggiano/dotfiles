{config, ...}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
}
