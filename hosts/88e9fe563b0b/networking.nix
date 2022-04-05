{lib, ...}: {
  networking.hostName = lib.mkForce null;
  networking.computerName = "88e9fe563b0b";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "Thunderbolt Ethernet Slot  1"
  ];
}
