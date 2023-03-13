function gi
    set api_url https://www.toptal.com/developers/gitignore/api
    if count $argv > /dev/null
        curl -sL $api_url/$argv
    else
        set chosen (curl -sL $api_url/list | string split , | fzf --multi --ansi --preview "curl -sL $api_url/{}" --preview-window default:hidden | string join ,)
        curl -sL $api_url/$chosen
    end
end
