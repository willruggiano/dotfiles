# Generated by Nix.
config.load_autoconfig(False)

c.aliases = {
    'autorefresh': 'spawn --userscript autorefresh',
    'nohl': 'search',
    'settings': 'open -t qute://settings',
}

config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl-y>', 'command-accept', mode='command')
config.bind('<Tab>', 'command-history-next', mode='command')
config.bind('<Shift-Tab>', 'command-history-prev', mode='command')

config.bind(';q', 'hint links run :set-cmd-text -s :quickmark-add {hint-url}')
config.unbind('q')  # as it will be the root of our quickmark hierarchy
config.bind('ql', 'set-cmd-text -s :quickmark-load')
config.bind('qL', 'set-cmd-text -s :quickmark-load -t')
config.bind('qa', 'quickmark-save')
config.bind('qd', 'quickmark-del')
config.unbind('b')  # as it will be the root of our bookmark hierarchy
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
    'brave': 'https://search.brave.com/search?q={}',
    'cpp': 'https://duckduckgo.com/?sites=cppreference.com&q={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'github': 'https://github.com/search?q={}',
    'google': 'https://google.com/search?q={}',
    'luarocks': 'https://luarocks.org/search?q={}',
    'nixpkgs': 'https://search.nixos.org/packages?channel=unstable&sort=relevance&type=packages&query={}',
    'pypi': 'https://pypi.org/project/{}',
    'sg': 'https://sourcegraph.com/search?q=context:global+{}&patternType=literal',
    'twitch': 'https://www.twitch.tv/{}',
})
c.url.searchengines['DEFAULT'] = c.url.searchengines['brave']

# security
c.content.tls.certificate_errors = 'ask-block-thirdparty'

config.source('colors.py')
