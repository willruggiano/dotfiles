# Generated by Nix.
config.load_autoconfig()

c.aliases = {'settings': 'open -t qute://settings'}

config.bind(';q', 'hint links run :set-cmd-text -s :quickmark-add {hint-url}')
config.unbind('q')  # as it will be the root of our quickmark hierarchy
config.bind('ql', 'set-cmd-text -s :quickmark-load')
config.bind('qL', 'set-cmd-text -s :quickmark-load -t')
config.bind('qa', 'quickmark-save')
config.bind('qd', 'quickmark-del')
config.unbind('b')  # as it will be the root of our bookmark hierarcy
config.bind('bl', 'set-cmd-text -s :bookmark-load')
config.bind('bL', 'set-cmd-text -s :bookmark-load -t')
config.bind('ba', 'bookmark-add')
config.bind('bd', 'bookmark-del')
config.bind('m', 'mode-enter set_mark')

# pass bindings
config.bind(',P', 'spawn --userscript qute-pass --password-only')
config.bind(',p', 'spawn --userscript qute-pass')
config.bind(',o', 'spawn --userscript qute-pass -o')
# mpv bindings
config.bind(';v', 'hint links spawn mpv {hint-url}')

c.editor.command = [
    'kitty', '-e', 'zsh', '-c', 'nvim +"call cursor({line},{column0})" {file}'
]

# default start page/search engine
c.url.default_page = 'https://github.com'
c.url.start_pages = ['https://github.com']
c.url.searchengines.update({
    'cpp': 'https://duckduckgo.com/?sites=cppreference.com&q={}',
    'duckduckgo': 'https://duckduckgo.com/?q={}',
    'github': 'https://github.com/{}',
    'google': 'https://google.com/search?q={}',
    'nixpkgs': 'https://search.nixos.org/packages?channel=unstable&sort=relevance&type=packages&query={}',
})
c.url.searchengines['DEFAULT'] = c.url.searchengines['duckduckgo']
