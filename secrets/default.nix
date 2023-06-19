let
  ecthelion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAIngPgrqRfYi/YTrd0+eVRbylSL+weBTtL819GgXUb bombadil@ecthelion";
  mothership = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXEBxFhZ88up2XVDN3SOMjuFNczXJz4ZWx1NJuq42Uc root@mothership";
in {
  # "bombadil@ecthelion.age".publicKeys = [ecthelion];
  "bombadil@mothership.age".publicKeys = [mothership];
  "cachix.age".publicKeys = [ecthelion mothership];
  "github.age".publicKeys = [ecthelion mothership];
  "slack.age".publicKeys = [ecthelion mothership];
  "sourcegraph.age".publicKeys = [ecthelion mothership];
  "spotify.age".publicKeys = [ecthelion mothership];
  "tendrel-test.ovpn.age".publicKeys = [ecthelion mothership];
  "tendrel-beta.ovpn.age".publicKeys = [ecthelion mothership];
  "wmruggiano@gmail.com.age".publicKeys = [ecthelion mothership];
}
