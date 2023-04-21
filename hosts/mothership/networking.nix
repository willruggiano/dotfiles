{config, ...}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking.wireless = {
    enable = true;
    environmentFile = config.age.secrets."networking.env".path;
    networks = {
      jorynmarv = {
        pskRaw = "@PSK_JORYNMARV@";
      };
      NETGEAR39 = {
        pskRaw = "@PSK_NETGEAR_39@";
      };
      NETGEAR39-5G = {
        pskRaw = "@PSK_NETGEAR_39_5G@";
      };
      "Pitter Patter" = {
        pskRaw = "@PSK_PITTER_PATTER@";
      };
    };
  };
}
