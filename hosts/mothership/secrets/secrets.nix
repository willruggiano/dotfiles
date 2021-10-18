let
  bombadil = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";
in
{
  "github.age".publicKeys = [ bombadil ];
  "wmruggiano@gmail.com.age".publicKeys = [ bombadil ];
}
