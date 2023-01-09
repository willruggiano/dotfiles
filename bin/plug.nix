{
  config,
  writeShellApplication,
  niv,
}:
writeShellApplication {
  name = "plug";
  runtimeInputs = [niv];
  text = ''
    case "$1" in
        link)
            target="$(readlink -f "$2")"
            link_path="$HOME/.local/share/nvim/site/pack/dev/start/"
            ln -sf "$target" "$link_path"
            ;;
        unlink)
            target="$(basename "$2")"
            rm "$HOME/.local/share/nvim/site/pack/dev/start/$target"
            ;;
        *)
            pushd "${config.dotfiles.dir}/modules/common/neovim/plugins" >/dev/null
            niv "$@"
            popd >/dev/null
            ;;
    esac
  '';
}
