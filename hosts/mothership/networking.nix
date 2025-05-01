{config, ...}: {
  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    wireless.iwd.enable = true;
  };
}
