let
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXEBxFhZ88up2XVDN3SOMjuFNczXJz4ZWx1NJuq42Uc root@mothership";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";
in {
  "bombadil@mothership.age".publicKeys = [root user];
  "willruggiano@github.age".publicKeys = [root user];
}
