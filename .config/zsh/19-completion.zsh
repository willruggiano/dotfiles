zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _extensions _complete _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' group-name ""
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
