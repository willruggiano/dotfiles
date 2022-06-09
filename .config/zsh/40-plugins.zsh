eval "$(thefuck --alias)"

export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^p' _atuin_search_widget
