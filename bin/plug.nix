{
  config,
  writeShellApplication,
  niv,
}:
writeShellApplication {
  name = "plug";
  runtimeInputs = [niv];
  text = ''
    pushd "${config.dotfiles.dir}/modules/common/neovim/plugins" >/dev/null
    niv "$@"
    popd >/dev/null
  '';
}
