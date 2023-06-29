let
  ecthelion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8WeTBtGhbaMf1TZ/aNFyJuEZpUo/N4ZA7F+5PIzjG1 root@ecthelion";
  bombadil_ecthelion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWXJHDkOTwqq+3W5JgBxGWyDNlhxVcQB/2lwBRwg8/f bombadil@ecthelion";
  mothership = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXEBxFhZ88up2XVDN3SOMjuFNczXJz4ZWx1NJuq42Uc root@mothership";
  bombadil_mothership = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";
in {
  "bombadil@ecthelion.age".publicKeys = [ecthelion bombadil_ecthelion];
  "bombadil@mothership.age".publicKeys = [mothership bombadil_mothership];
  "cachix.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
  "github.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
  "slack.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
  "sourcegraph.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
  "spotify.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
  "wmruggiano@gmail.com.age".publicKeys = [ecthelion bombadil_ecthelion mothership bombadil_mothership];
}
