{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tunnel9";
  version = "nightly";
  src = fetchFromGitHub {
    owner = "sio2boss";
    repo = finalAttrs.pname;
    rev = "main";
    hash = "sha256-jxg9swaNroBN8tUBtxyKa9K3syt6gSJauYkWXj6/ikA=";
  };
  vendorHash = "sha256-QIe2U5v6Bo+9E2X+Vg/94JN9K0jpNtYsiHgx+bw3jvQ=";
  meta = {
    description = "A terminal user interface (TUI) for managing SSH tunnels";
    homepage = "https://github.com/sio2boss/tunnel9";
    licenses = lib.licenses.mit;
  };
})
