{
  writeShellApplication,
  fzf,
  gnused,
  networkmanager,
  ...
}:
writeShellApplication {
  name = "fzf-wifi";
  runtimeInputs = [fzf gnused networkmanager];
  text = ''
    has() {
      local verbose=false
      if [[ $1 == '-v' ]]; then
        verbose=true
        shift
      fi
      for c in "$@"; do
        c="''${c%% *}"
        if ! command -v "$c" &>/dev/null; then
          [[ "$verbose" == true ]] && err "$c not found"
          return 1
        fi
      done
    }

    err() {
      printf '\e[31m%s\e[0m\n' "$*" >&2
    }

    die() {
      (($# > 0)) && err "$*"
      exit 1
    }

    nmcli -d wifi rescan 2>/dev/null || true
    network=$(nmcli --color yes device wifi | fzf --ansi --height 40% --reverse --cycle --header-lines 1)
    [[ -z "$network" ]] && exit
    network=$(sed -r 's/^\s*\*?\s*//; s/\s*(Ad-Hoc|Infra).*//' <<<"$network")
    SSID=$(echo "$network" | grep -o "\s.*$" | sed 's/^[[:space:]]*//')
    echo "connecting to \"''${SSID}\"..."
    sudo nmcli -a device wifi connect "$SSID"
  '';
}
