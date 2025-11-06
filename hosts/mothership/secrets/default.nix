let
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXEBxFhZ88up2XVDN3SOMjuFNczXJz4ZWx1NJuq42Uc root@mothership";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";
in {
  "anthropic.age".publicKeys = [host user];
  "bombadil@mothership.age".publicKeys = [host user];
  "gemini.age".publicKeys = [host user];
  "openai.age".publicKeys = [host user];
  "willruggiano@github.age".publicKeys = [host user];
}
