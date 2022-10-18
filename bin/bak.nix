{
  writeShellApplication,
  coreutils,
  ...
}:
writeShellApplication {
  name = "bak";
  runtimeInputs = [coreutils];
  text = ''
    behavior="backup"
    file=""

    while (( $# )); do
        case $1 in
            -r)
                behavior="restore"
                ;;
            *)
                file=$1
                ;;
        esac
        shift
    done

    if [[ -z "$file" ]]; then
        echo "must supply a target file or directory"
        exit 1
    fi

    abs=$(readlink -f "$file")

    case "$behavior" in
        backup)
            mv "$file" "$abs.bak" && echo "$file -> $abs.bak"
            ;;
        restore)
            orig=$(basename "$abs" .bak)
            mv "$abs" "$orig" && echo "$abs -> $orig"
            ;;
    esac
  '';
}
