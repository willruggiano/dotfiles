{
  writeShellApplication,
  cachix,
  jq,
  nix,
  ...
}:
writeShellApplication {
  name = "nix-build-cachix";
  runtimeInputs = [cachix jq nix];
  text = ''
    nix build --json "$@" | jq -r '.[].outputs | to_entries[].value' | cachix push willruggiano
  '';
}
