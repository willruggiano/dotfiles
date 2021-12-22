function encrypt() {
    local out="$1.$(date +%s).enc"
    gpg --encrypt --armor --output $out -r wmruggiano@gmail.com "$1" && echo "$1 -> $out"
}

function decrypt() {
    local out=$(echo "$1" | rev | cut -c16- | rev)
    gpg --decrypt --output $out "$1" && echo "$1 -> $out"
}

function gpg-reset-card() {
    gpg-connect-agent "scd serialno" "learn --force" /bye
}

function git-turtle() {
    local n=""
    local branch=""
    local dryrun=false
    for a in "$@"; do
    case "$a" in
        -n)
            shift; n="$1"; shift
            ;;
        -b)
            shift; branch="$1"; shift
            ;;
        --dryrun)
            shift; dryrun=true
            ;;
    esac
    done
    [[ -z $n ]] || [[ -z $branch ]] && die '-n and -b|--branch are required'
    local git_reset="git reset --keep HEAD~$n"
    local git_check="git checkout -t -b $branch"
    local git_pick="git cherry-pick ..HEAD@{2}"
    if $dryrun; then
        echo "+ $git_reset"
        echo "+ $git_check"
        echo "+ $git_pick"
    else
        eval "$git_reset && $git_check && $git_pick"
    fi
}

function lg() {
    if [[ $# -eq 0 ]]; then
        lazygit
    else
        command git $@
    fi
}
