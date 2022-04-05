let
  bombadil = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";
in {
  "expressvpn-auth-user-pass.age".publicKeys = [bombadil];
  "expressvpn-dallas.age".publicKeys = [bombadil];
  "github.age".publicKeys = [bombadil];
  "spotify.age".publicKeys = [bombadil];
  "wmruggiano@gmail.com.age".publicKeys = [bombadil];
}
